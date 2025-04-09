import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:im_mobile/models/conversation_member_model.dart';

part '../generated/models/conversation_detail_model.freezed.dart';
part '../generated/models/conversation_detail_model.g.dart';

@freezed
abstract class ConversationDetailModel with _$ConversationDetailModel {
  const factory ConversationDetailModel({
    required int id,
    required String type,
    String? name,
    String? avatar,
    required int createdAt,
    required int updatedAt,
    required List<ConversationMemberModel> members,
  }) = _ConversationDetailModel;

  /// 从JSON映射创建ConversationDetailModel实例
  factory ConversationDetailModel.fromJson(Map<String, dynamic> json) => 
      _$ConversationDetailModelFromJson(json);
}
