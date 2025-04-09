import 'package:dio/dio.dart' hide LogInterceptor;
import 'package:im_mobile/models/base_response.dart';
import 'package:im_mobile/utils/logInterceptor.dart';
import 'package:im_mobile/utils/shared_preferences_util.dart';
import 'package:im_mobile/utils/toast_util.dart';
import 'package:im_mobile/utils/logger.dart'; // 添加日志工具导入

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  late final Dio _dio;

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.2.3:8080/api',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // 添加日志拦截器
    _dio.interceptors.add(LogInterceptor());

    // 添加原有的拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = SharedPreferencesUtil.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.data?['code'] != 200) {
            final message = response.data?['message'] ?? '请求失败';
            ToastUtil.showError(message);
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          String errorMessage = '网络请求失败';
          if (e.type == DioExceptionType.connectionTimeout || 
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.sendTimeout) {
            errorMessage = '网络连接超时';
          } else if (e.type == DioExceptionType.badResponse) {
            switch (e.response?.statusCode) {
              case 400:
                errorMessage = e.response?.data?['message'] ?? '请求参数错误';
                break;
              case 401:
                errorMessage = '未授权，请重新登录';
                break;
              case 403:
                errorMessage = '无权限访问';
                break;
              case 404:
                errorMessage = '请求资源不存在';
                break;
              case 500:
                errorMessage = '服务器内部错误';
                break;
              default:
                errorMessage = e.response?.data?['message'] ?? '服务器响应错误';
            }
          } else if (e.type == DioExceptionType.cancel) {
            errorMessage = '请求已取消';
          }
          
          return handler.next(
            DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              type: e.type,
              error: errorMessage,
            ),
          );
        },
      ),
    );
  }

  Future<BaseResponse<T>> get<T>(String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) fromJsonT,
  }) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    return BaseResponse.fromJson(response.data, fromJsonT);
  }

  Future<BaseResponse<T>> post<T>(String path, {
    dynamic data,
     Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) fromJsonT,
  }) async {
    final response = await _dio.post(path, data: data, queryParameters: queryParameters);
    return BaseResponse.fromJson(response.data, fromJsonT);
  }

  Future<BaseResponse<T>> put<T>(String path, {
    dynamic data,
    required T Function(dynamic json) fromJsonT,
  }) async {
    final response = await _dio.put(path, data: data);
    return BaseResponse.fromJson(response.data, fromJsonT);
  }

  Future<BaseResponse<T>> delete<T>(String path, {
    required T Function(dynamic json) fromJsonT,
  }) async {
    final response = await _dio.delete(path);
    return BaseResponse.fromJson(response.data, fromJsonT);
  }
}
