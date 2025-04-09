import 'dart:convert';

import 'package:im_mobile/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static late SharedPreferences _prefs;
  static bool _initialized = false;

  /// 初始化SharedPreferences，应用启动时调用一次
  static Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // Token相关操作
  static Future<bool> setToken(String token) async {
    return await _prefs.setString('token', token);
  }

  static String? getToken() {
    return _prefs.getString('token');
  }

  static Future<bool> removeToken() async {
    return await _prefs.remove('token');
  }

  // 用户信息相关操作
  static Future<bool> setUserInfo(String userInfo) async {
    return await _prefs.setString('user_info', userInfo);
  }

  static UserModel? getUserInfo() {
    if(_prefs.getString('user_info') == null){
      return null;
    }
    Map<String,dynamic> str = jsonDecode(_prefs.getString('user_info')?? '{}');
    return UserModel.fromJson(str);
  }

  static Future<bool> removeUserInfo() async {
    return await _prefs.remove('user_info');
  }

  // 清除所有数据
  static Future<bool> clear() async {
    return await _prefs.clear();
  }
}