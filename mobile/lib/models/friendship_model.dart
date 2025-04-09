import 'package:im_mobile/models/contact_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/friendship_model.freezed.dart';
part '../generated/models/friendship_model.g.dart';

@freezed
abstract class FriendshipModel with _$FriendshipModel {
  const factory FriendshipModel({
    required int id,
    int? requesterId,
    int? addresseeId,
    required String status, // PENDING, ACCEPTED, REJECTED
    required num createdAt,
    num? updatedAt,
    ContactModel? requester,
    ContactModel? addressee,
  }) = _FriendshipModel;

  /// 从JSON映射创建FriendshipModel实例
  factory FriendshipModel.fromJson(Map<String, dynamic> json) => _$FriendshipModelFromJson(json);
}
