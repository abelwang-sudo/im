import 'package:im_mobile/models/contact_model.dart';
import 'package:im_mobile/models/conversation_model.dart';
import 'package:im_mobile/models/friendship_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/chat_message_model.freezed.dart';
part '../generated/models/chat_message_model.g.dart';

/// 消息类型枚举，对应后端的MessageType
enum MessageType {
  @JsonValue('CHAT')
  chat,
  @JsonValue('JOIN')
  join,
  @JsonValue('LEAVE')
  leave,
  @JsonValue('TYPING')
  typing,
  @JsonValue('HEARTBEAT')
  heartbeat,
  @JsonValue('PING')
  ping,
  @JsonValue('PONG')
  pong,
  @JsonValue('NOTICE')
  notice
}

/// 聊天消息实体类，对应后端的ChatMessage实体
@freezed
abstract class ChatMessageModel with _$ChatMessageModel {
  const factory ChatMessageModel({
    @JsonKey(includeIfNull: false) int? id,
    @JsonKey(name: 'type') required MessageType type,
    @JsonKey(includeIfNull: false) MessageContent? content,
    @JsonKey(includeIfNull: false) num? sender,
    @JsonKey(includeIfNull: false) String? senderAvatar,
    @JsonKey(includeIfNull: false) String? senderNickname,
    @JsonKey(includeIfNull: false) num? recipient,
    @JsonKey(includeIfNull: false) int? conversationId,
    required int timestamp,
    @JsonKey(name: 'read') @Default(false) bool isRead,
  }) = _ChatMessageModel;

  /// 从JSON映射创建ChatMessageModel实例
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => 
      _$ChatMessageModelFromJson(json);
  
  /// 创建心跳消息
  factory ChatMessageModel.ping() {
    return ChatMessageModel(
      type: MessageType.ping,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
  
  /// 创建心跳响应消息
  factory ChatMessageModel.pong() {
    return ChatMessageModel(
      type: MessageType.pong,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
  
  /// 创建聊天消息
  factory ChatMessageModel.chat({
    required MessageContent content,
    required int conversationId,
  }) {
    return ChatMessageModel(
      type: MessageType.chat,
      conversationId: conversationId,
      content: content,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }


}

@JsonSerializable(includeIfNull: false)
class MessageContent{

  late MessageContentType type;
  late String text;
  String? action;
  FriendshipModel? friendship;
  ConversationModel? conversation;
  UserStatus? status;


  MessageContent(this.type, this.text);

  factory MessageContent.fromJson(Map<String, dynamic> json) =>
      _$MessageContentFromJson(json);

  /// 将ChatMessageModel实例转换为JSON映射
  Map<String, dynamic> toJson() => _$MessageContentToJson(this);
}

enum MessageContentType {
  @JsonValue('CONTACT')
  contact,
  @JsonValue('GROUP')
  group,
  @JsonValue('TEXT')
  text,
  @JsonValue('VOICE')
  voice,
  @JsonValue('CONVERSATION')
  conversation,
  @JsonValue('JOIN')
  join,
  @JsonValue('LEAVE')
  leave,
  @JsonValue('MEMBER')
  member,
  @JsonValue('USER_STATUS')
  userStatus,
}