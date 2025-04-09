// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/conversation_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationMemberModel _$ConversationMemberModelFromJson(
        Map<String, dynamic> json) =>
    _ConversationMemberModel(
      id: (json['id'] as num).toInt(),
      conversationId: (json['conversationId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      nickname: json['nickname'] as String?,
      displayName: json['displayName'] as String?,
      avatar: json['avatar'] as String?,
      role: json['role'] as String?,
      unreadCount: (json['unreadCount'] as num).toInt(),
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
    );

Map<String, dynamic> _$ConversationMemberModelToJson(
        _ConversationMemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'displayName': instance.displayName,
      'avatar': instance.avatar,
      'role': instance.role,
      'unreadCount': instance.unreadCount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
