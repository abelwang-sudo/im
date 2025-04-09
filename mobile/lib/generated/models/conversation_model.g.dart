// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) =>
    _ConversationModel(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      lastMessage: json['lastMessage'] == null
          ? null
          : ChatMessageModel.fromJson(
              json['lastMessage'] as Map<String, dynamic>),
      createdAt: (json['createdAt'] as num?)?.toInt(),
      updatedAt: (json['updatedAt'] as num?)?.toInt(),
      member: json['member'] == null
          ? null
          : ConversationMemberModel.fromJson(
              json['member'] as Map<String, dynamic>),
      group: json['group'] == null
          ? null
          : GroupModel.fromJson(json['group'] as Map<String, dynamic>),
      requireApproval: json['requireApproval'] as bool? ?? false,
      onlyAdminCanInvite: json['onlyAdminCanInvite'] as bool? ?? false,
      onlyAdminCanSpeak: json['onlyAdminCanSpeak'] as bool? ?? false,
    );

Map<String, dynamic> _$ConversationModelToJson(_ConversationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'avatar': instance.avatar,
      'lastMessage': instance.lastMessage,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'member': instance.member,
      'group': instance.group,
      'requireApproval': instance.requireApproval,
      'onlyAdminCanInvite': instance.onlyAdminCanInvite,
      'onlyAdminCanSpeak': instance.onlyAdminCanSpeak,
    };
