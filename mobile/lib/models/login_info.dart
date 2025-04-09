import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/login_info.freezed.dart';
part '../generated/models/login_info.g.dart';

@freezed
abstract class LoginInfo with _$LoginInfo {
  const factory LoginInfo({
    required int id,
    String? avatar,
    required String token,
    required String username,
    String? nickname,
    required String email,
  }) = _LoginInfo;

  /// 从JSON映射创建UserModel实例
  factory LoginInfo.fromJson(Map<String, dynamic> json) => _$LoginInfoFromJson(json);
}