// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/join_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JoinRequestModel _$JoinRequestModelFromJson(Map<String, dynamic> json) =>
    _JoinRequestModel(
      id: (json['id'] as num).toInt(),
      applicant: json['applicant'] == null
          ? null
          : UserModel.fromJson(json['applicant'] as Map<String, dynamic>),
      conversationId: (json['conversationId'] as num).toInt(),
      reason: json['reason'] as String?,
      status: json['status'] as String,
      createdAt: (json['createdAt'] as num?)?.toInt(),
      updatedAt: (json['updatedAt'] as num?)?.toInt(),
    );

Map<String, dynamic> _$JoinRequestModelToJson(_JoinRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'applicant': instance.applicant,
      'conversationId': instance.conversationId,
      'reason': instance.reason,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
