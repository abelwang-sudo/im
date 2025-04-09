// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageContent _$MessageContentFromJson(Map<String, dynamic> json) =>
    MessageContent(
      $enumDecode(_$MessageContentTypeEnumMap, json['type']),
      json['text'] as String,
    )
      ..action = json['action'] as String?
      ..friendship = json['friendship'] == null
          ? null
          : FriendshipModel.fromJson(json['friendship'] as Map<String, dynamic>)
      ..conversation = json['conversation'] == null
          ? null
          : ConversationModel.fromJson(
              json['conversation'] as Map<String, dynamic>)
      ..status = $enumDecodeNullable(_$UserStatusEnumMap, json['status']);

Map<String, dynamic> _$MessageContentToJson(MessageContent instance) =>
    <String, dynamic>{
      'type': _$MessageContentTypeEnumMap[instance.type]!,
      'text': instance.text,
      if (instance.action case final value?) 'action': value,
      if (instance.friendship case final value?) 'friendship': value,
      if (instance.conversation case final value?) 'conversation': value,
      if (_$UserStatusEnumMap[instance.status] case final value?)
        'status': value,
    };

const _$MessageContentTypeEnumMap = {
  MessageContentType.contact: 'CONTACT',
  MessageContentType.group: 'GROUP',
  MessageContentType.text: 'TEXT',
  MessageContentType.voice: 'VOICE',
  MessageContentType.conversation: 'CONVERSATION',
  MessageContentType.join: 'JOIN',
  MessageContentType.leave: 'LEAVE',
  MessageContentType.member: 'MEMBER',
  MessageContentType.userStatus: 'USER_STATUS',
};

const _$UserStatusEnumMap = {
  UserStatus.online: 'ONLINE',
  UserStatus.offline: 'OFFLINE',
};

_ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    _ChatMessageModel(
      id: (json['id'] as num?)?.toInt(),
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      content: json['content'] == null
          ? null
          : MessageContent.fromJson(json['content'] as Map<String, dynamic>),
      sender: json['sender'] as num?,
      senderAvatar: json['senderAvatar'] as String?,
      senderNickname: json['senderNickname'] as String?,
      recipient: json['recipient'] as num?,
      conversationId: (json['conversationId'] as num?)?.toInt(),
      timestamp: (json['timestamp'] as num).toInt(),
      isRead: json['read'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatMessageModelToJson(_ChatMessageModel instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'type': _$MessageTypeEnumMap[instance.type]!,
      if (instance.content case final value?) 'content': value,
      if (instance.sender case final value?) 'sender': value,
      if (instance.senderAvatar case final value?) 'senderAvatar': value,
      if (instance.senderNickname case final value?) 'senderNickname': value,
      if (instance.recipient case final value?) 'recipient': value,
      if (instance.conversationId case final value?) 'conversationId': value,
      'timestamp': instance.timestamp,
      'read': instance.isRead,
    };

const _$MessageTypeEnumMap = {
  MessageType.chat: 'CHAT',
  MessageType.join: 'JOIN',
  MessageType.leave: 'LEAVE',
  MessageType.typing: 'TYPING',
  MessageType.heartbeat: 'HEARTBEAT',
  MessageType.ping: 'PING',
  MessageType.pong: 'PONG',
  MessageType.notice: 'NOTICE',
};
