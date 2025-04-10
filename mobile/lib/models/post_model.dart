import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:im_mobile/models/user_model.dart';

part '../generated/models/post_model.freezed.dart';
part '../generated/models/post_model.g.dart';

/// 媒体文件模型，表示图片、视频等媒体文件
@freezed
abstract class MediaModel with _$MediaModel {
  const factory MediaModel({
    required String mediaUrl,
    required String mediaType,
  }) = _MediaModel;

  /// 从JSON映射创建MediaModel实例
  factory MediaModel.fromJson(Map<String, dynamic> json) => 
      _$MediaModelFromJson(json);
}

/// 动态实体类，对应后端的Post实体
@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    required int id,
    required int userId,
    String? username,
    String? nickname,
    String? avatar,
    required String content,
    List<MediaModel>? medias,
    String? mediaType,
    required int createdAt,
    required int likeCount,
    bool? liked,
  }) = _PostModel;

  /// 从JSON映射创建PostModel实例
  factory PostModel.fromJson(Map<String, dynamic> json) => 
      _$PostModelFromJson(json);
}