// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/conversation_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationDetailModel _$ConversationDetailModelFromJson(
        Map<String, dynamic> json) =>
    _ConversationDetailModel(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
      members: (json['members'] as List<dynamic>)
          .map((e) =>
              ConversationMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConversationDetailModelToJson(
        _ConversationDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'avatar': instance.avatar,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'members': instance.members,
    };
