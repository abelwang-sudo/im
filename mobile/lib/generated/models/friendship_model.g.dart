// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/friendship_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FriendshipModel _$FriendshipModelFromJson(Map<String, dynamic> json) =>
    _FriendshipModel(
      id: (json['id'] as num).toInt(),
      requesterId: (json['requesterId'] as num?)?.toInt(),
      addresseeId: (json['addresseeId'] as num?)?.toInt(),
      status: json['status'] as String,
      createdAt: json['createdAt'] as num,
      updatedAt: json['updatedAt'] as num?,
      requester: json['requester'] == null
          ? null
          : ContactModel.fromJson(json['requester'] as Map<String, dynamic>),
      addressee: json['addressee'] == null
          ? null
          : ContactModel.fromJson(json['addressee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FriendshipModelToJson(_FriendshipModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requesterId': instance.requesterId,
      'addresseeId': instance.addresseeId,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'requester': instance.requester,
      'addressee': instance.addressee,
    };
