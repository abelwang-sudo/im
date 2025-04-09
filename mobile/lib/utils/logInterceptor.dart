
import 'package:dio/dio.dart';

import 'logger.dart';

/// 专用于日志打印的拦截器
class LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Log.i('HttpClient', '┌────── 请求开始 ──────');
    Log.i('HttpClient', '| ${options.method} ${options.uri}');
    Log.i('HttpClient', '| 请求头: ${options.headers}');
    
    if (options.data != null) {
      Log.i('HttpClient', '| 请求数据: ${options.data}');
    }
    
    if (options.queryParameters.isNotEmpty) {
      Log.i('HttpClient', '| 查询参数: ${options.queryParameters}');
    }
    
    Log.i('HttpClient', '└────── 请求结束 ──────');
    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Log.i('HttpClient', '┌────── 响应开始 ──────');
    Log.i('HttpClient', '| ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}');
    Log.i('HttpClient', '| 响应时间: ${DateTime.now()}');
    Log.i('HttpClient', '| 响应数据: ${response.data}');
    Log.i('HttpClient', '└────── 响应结束 ──────');
    
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Log.e('HttpClient', '┌────── 错误开始 ──────');
    Log.e('HttpClient', '| ${err.requestOptions.method} ${err.requestOptions.uri}');
    Log.e('HttpClient', '| 错误类型: ${err.type}');
    
    if (err.response != null) {
      Log.e('HttpClient', '| 状态码: ${err.response?.statusCode}');
      Log.e('HttpClient', '| 错误响应: ${err.response?.data}');
    }
    
    Log.e('HttpClient', '| 错误信息: ${err.message}');
    Log.e('HttpClient', '└────── 错误结束 ──────');
    
    super.onError(err, handler);
  }
}