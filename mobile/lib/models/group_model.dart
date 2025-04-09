import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:im_mobile/models/contact_model.dart';

part '../generated/models/group_model.freezed.dart';
part '../generated/models/group_model.g.dart';

@freezed
abstract class GroupOwnerModel with _$GroupOwnerModel {
  const factory GroupOwnerModel({
    required int id,
    required String username,
    required String email,
    String? nickname,
    String? avatar,
    required int createdAt,
    required int updatedAt,
    @JsonKey(includeIfNull: false)
    String? password,
  }) = _GroupOwnerModel;

  /// 从JSON映射创建GroupOwnerModel实例
  factory GroupOwnerModel.fromJson(Map<String, dynamic> json) => _$GroupOwnerModelFromJson(json);
}


@freezed
abstract class GroupModel with _$GroupModel {
  const factory GroupModel({
    required int id,
    required int conversationId,
    required String name,
    String? description,
    String? avatar,
    GroupOwnerModel? owner,
  }) = _GroupModel;

  /// 从JSON映射创建GroupModel实例
  factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);
}

@JsonSerializable()
class GroupMemberModel {
  final int id;
  final int groupId;
  final int userId;
  final String role; // OWNER, ADMIN, MEMBER
  final int createdAt;
  final int updatedAt;
  final ContactModel? user;

  GroupMemberModel({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  /// 从JSON映射创建GroupMemberModel实例
  factory GroupMemberModel.fromJson(Map<String, dynamic> json) => _$GroupMemberModelFromJson(json);

  /// 将GroupMemberModel实例转换为JSON映射
  Map<String, dynamic> toJson() => _$GroupMemberModelToJson(this);
}
