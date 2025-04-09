// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMemberModel _$GroupMemberModelFromJson(Map<String, dynamic> json) =>
    GroupMemberModel(
      id: (json['id'] as num).toInt(),
      groupId: (json['groupId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      role: json['role'] as String,
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
      user: json['user'] == null
          ? null
          : ContactModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GroupMemberModelToJson(GroupMemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'userId': instance.userId,
      'role': instance.role,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'user': instance.user,
    };

_GroupOwnerModel _$GroupOwnerModelFromJson(Map<String, dynamic> json) =>
    _GroupOwnerModel(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
      password: json['password'] as String?,
    );

Map<String, dynamic> _$GroupOwnerModelToJson(_GroupOwnerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      if (instance.password case final value?) 'password': value,
    };

_GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => _GroupModel(
      id: (json['id'] as num).toInt(),
      conversationId: (json['conversationId'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      avatar: json['avatar'] as String?,
      owner: json['owner'] == null
          ? null
          : GroupOwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GroupModelToJson(_GroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'name': instance.name,
      'description': instance.description,
      'avatar': instance.avatar,
      'owner': instance.owner,
    };
