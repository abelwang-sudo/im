// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContactModel _$ContactModelFromJson(Map<String, dynamic> json) =>
    _ContactModel(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: json['createdAt'] as num,
      updatedAt: json['updatedAt'] as num,
      status: $enumDecodeNullable(_$UserStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$ContactModelToJson(_ContactModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'status': _$UserStatusEnumMap[instance.status],
    };

const _$UserStatusEnumMap = {
  UserStatus.online: 'ONLINE',
  UserStatus.offline: 'OFFLINE',
};
