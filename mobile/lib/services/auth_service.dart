import 'package:im_mobile/models/base_response.dart';
import 'package:im_mobile/models/login_info.dart';
import 'package:im_mobile/models/user_model.dart';
import 'package:im_mobile/utils/http_client.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class AuthService {
  static final HttpClient _httpClient = HttpClient();

  Future<BaseResponse<UserModel>> register({
    required String email,
    required String password,
  }) async {
    return _httpClient.post('/users/register', 
      data: {
        'email': email,
        'password': password,
      },
      fromJsonT: (dynamic json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<LoginInfo>> login({
    required String email,
    required String password,
  }) async {
    return _httpClient.post('/users/login', 
      data: {
        'username': email,
        'password': password,
      },
      fromJsonT: (dynamic json) => LoginInfo.fromJson(json as Map<String, dynamic>),
    );
  }
  
  // 更新用户信息
  Future<BaseResponse<UserModel>> updateUserProfile(Map<String, dynamic> data) async {
    return _httpClient.put('/users/profile',
      data: data,
      fromJsonT: (dynamic json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }
  
  // 获取文件上传预签名URL
  Future<BaseResponse<Map<String, dynamic>>> getUploadUrl(String fileName, String contentType) async {
    return _httpClient.get('/files/upload-url',
      queryParameters: {
        'fileName': fileName,
        'contentType': contentType,
      },
      fromJsonT: (dynamic json) => json as Map<String, dynamic>,
    );
  }
  
  // 使用预签名URL上传文件
  Future<bool> uploadFileWithPresignedUrl(String uploadUrl, File file, String contentType) async {
    try {
      final response = await Dio().put(
         uploadUrl,
        data: await file.readAsBytes(),
        options: Options(
          contentType: contentType
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  // 修改密码
  static Future<BaseResponse<String>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    return _httpClient.post('/users/change-password', 
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }, fromJsonT: (dynamic json) => json as String,
    );
  }
}