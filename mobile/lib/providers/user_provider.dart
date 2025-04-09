import 'dart:convert';
import 'dart:io';
import 'package:im_mobile/models/user_model.dart';
import 'package:im_mobile/models/login_info.dart';
import 'package:im_mobile/models/base_response.dart';
import 'package:im_mobile/services/auth_service.dart';
import 'package:im_mobile/utils/logger.dart';
import 'package:im_mobile/utils/shared_preferences_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as path;
import 'package:im_mobile/services/websocket_service.dart';

part '../generated/providers/user_provider.g.dart';

// 用户状态提供者
@Riverpod(keepAlive: true)
class User extends _$User {
  final authService = AuthService();

  @override
  UserModel? build() {
    return SharedPreferencesUtil.getUserInfo();
  }

  // 登录功能
  Future<bool> login(String email, String password) async {
    try {
      BaseResponse<LoginInfo> response = await authService.login(email: email, password: password);
      
      if (response.code == 200 && response.data != null) {
        LoginInfo loginInfo = response.data!;
        
        // 保存用户信息
        await setUser(UserModel.fromJson(loginInfo.toJson()));
        
        // 保存token
        await SharedPreferencesUtil.setToken(loginInfo.token);
        
        Log.i('UserProvider', '用户登录成功');
        return true;
      } else {
        Log.e('UserProvider', '登录失败: ${response.message}');
        return false;
      }
    } catch (e, stack) {
      Log.e('UserProvider', '登录失败', e, stack);
      return false;
    }
  }

  Future<void> setUser(UserModel user) async {
    SharedPreferencesUtil.setUserInfo(jsonEncode(user.toJson()));
    state = user;
  }

  // 退出登录
  Future<void> logout() async {
    try {
      // 断开WebSocket连接
      WebSocketService().disconnect();
      
      // 清除本地缓存
      await clearUser();
      
      Log.i('UserProvider', '用户已成功退出登录');
    } catch (e, s) {
      Log.e('UserProvider', '退出登录失败', e, s);
      // 即使API调用失败，也要清除本地数据
      await clearUser();
    }
  }

  Future<void> clearUser() async {
    SharedPreferencesUtil.clear();
    state = null;
  }
  
  // 更新用户信息
  Future<bool> updateUserInfo(Map<String, dynamic> data) async {
    try {
      final authService = AuthService();
      final response = await authService.updateUserProfile(data);

      if (response.code == 200 && response.data != null) {
        // 更新状态
        await setUser(response.data!);
        return true;
      }
      return false;
    } catch (e,s) {
      Log.e('UserProvider', '更新用户信息失败', e,s);
      return false;
    }
  }
  
  // 上传头像
  Future<bool> uploadAvatar(File imageFile) async {
    try {
      final fileName = path.basename(imageFile.path);
      final contentType = 'image/${path.extension(fileName).replaceAll('.', '')}';
      
      // 获取预签名URL
      final urlResponse = await authService.getUploadUrl(fileName, contentType);
      
      if (urlResponse.code != 200 || urlResponse.data == null) {
        return false;
      }
      
      final uploadUrl = urlResponse.data!['uploadUrl'] as String;
      final fileUrl = urlResponse.data!['fileUrl'] as String;
      
      // 上传文件
      final uploadSuccess = await authService.uploadFileWithPresignedUrl(
        uploadUrl, 
        imageFile, 
        contentType
      );
      
      if (uploadSuccess) {
        // 更新用户头像
        return await updateUserInfo({'avatar': fileUrl});
      }
      
      return false;
    } catch (e) {
      Log.e('UserProvider', '上传头像失败', e);
      return false;
    }
  }

   Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
     // 调用 API 修改密码
     final response = await AuthService.changePassword(oldPassword: oldPassword,newPassword: newPassword);

     return response.code == 200;
  }
}
