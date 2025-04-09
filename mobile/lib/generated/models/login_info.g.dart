// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/login_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginInfo _$LoginInfoFromJson(Map<String, dynamic> json) => _LoginInfo(
      id: (json['id'] as num).toInt(),
      avatar: json['avatar'] as String?,
      token: json['token'] as String,
      username: json['username'] as String,
      nickname: json['nickname'] as String?,
      email: json['email'] as String,
    );

Map<String, dynamic> _$LoginInfoToJson(_LoginInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'avatar': instance.avatar,
      'token': instance.token,
      'username': instance.username,
      'nickname': instance.nickname,
      'email': instance.email,
    };
