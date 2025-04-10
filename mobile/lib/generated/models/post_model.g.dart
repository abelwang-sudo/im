// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaModel _$MediaModelFromJson(Map<String, dynamic> json) => _MediaModel(
      mediaUrl: json['mediaUrl'] as String,
      mediaType: json['mediaType'] as String,
    );

Map<String, dynamic> _$MediaModelToJson(_MediaModel instance) =>
    <String, dynamic>{
      'mediaUrl': instance.mediaUrl,
      'mediaType': instance.mediaType,
    };

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      username: json['username'] as String?,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      content: json['content'] as String,
      medias: (json['medias'] as List<dynamic>?)
          ?.map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      mediaType: json['mediaType'] as String?,
      createdAt: (json['createdAt'] as num).toInt(),
      likeCount: (json['likeCount'] as num).toInt(),
      liked: json['liked'] as bool?,
    );

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'username': instance.username,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'content': instance.content,
      'medias': instance.medias,
      'mediaType': instance.mediaType,
      'createdAt': instance.createdAt,
      'likeCount': instance.likeCount,
      'liked': instance.liked,
    };
