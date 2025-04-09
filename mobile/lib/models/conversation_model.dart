import 'package:im_mobile/models/conversation_member_model.dart';
import 'package:im_mobile/models/group_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:im_mobile/models/chat_message_model.dart';

part '../generated/models/conversation_model.freezed.dart';
part '../generated/models/conversation_model.g.dart';

/// 会话数据模型，用于表示用户的聊天会话
@freezed
abstract class ConversationModel with _$ConversationModel {
  const ConversationModel._();

  const factory ConversationModel({
    /// 会话ID
    required int id,
    
    /// 会话类型：单聊或群聊
    @JsonKey(name: 'type') required String type,
    
    /// 会话名称
    @JsonKey(name: 'name') String? name,
    
    /// 会话头像
    @JsonKey(name: 'avatar') String? avatar,
    ChatMessageModel? lastMessage,
    int? createdAt,
    int? updatedAt,
    ConversationMemberModel? member,
    GroupModel? group,
    @Default(false) bool requireApproval,
    @Default(false) bool onlyAdminCanInvite,
    @Default(false) bool onlyAdminCanSpeak,
  }) = _ConversationModel;

  /// 从JSON映射创建ConversationModel实例
  factory ConversationModel.fromJson(Map<String, dynamic> json) => 
      _$ConversationModelFromJson(json);

  // 计算属性
  bool get isOwner => member?.role == "OWNER";
  bool get isAdmin => member?.role == "ADMIN" || member?.role == "OWNER";
  bool get isGroupAndAdmin => type == 'GROUP' && isAdmin;
  bool get isGroup => type == 'GROUP';
  bool get isInvite => (onlyAdminCanInvite && isAdmin) || !onlyAdminCanInvite;
}