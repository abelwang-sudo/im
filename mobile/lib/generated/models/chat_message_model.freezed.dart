// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../models/chat_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessageModel {
  @JsonKey(includeIfNull: false)
  int? get id;
  @JsonKey(name: 'type')
  MessageType get type;
  @JsonKey(includeIfNull: false)
  MessageContent? get content;
  @JsonKey(includeIfNull: false)
  num? get sender;
  @JsonKey(includeIfNull: false)
  String? get senderAvatar;
  @JsonKey(includeIfNull: false)
  String? get senderNickname;
  @JsonKey(includeIfNull: false)
  num? get recipient;
  @JsonKey(includeIfNull: false)
  int? get conversationId;
  int get timestamp;
  @JsonKey(name: 'read')
  bool get isRead;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatMessageModelCopyWith<ChatMessageModel> get copyWith =>
      _$ChatMessageModelCopyWithImpl<ChatMessageModel>(
          this as ChatMessageModel, _$identity);

  /// Serializes this ChatMessageModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatMessageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.senderAvatar, senderAvatar) ||
                other.senderAvatar == senderAvatar) &&
            (identical(other.senderNickname, senderNickname) ||
                other.senderNickname == senderNickname) &&
            (identical(other.recipient, recipient) ||
                other.recipient == recipient) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      content,
      sender,
      senderAvatar,
      senderNickname,
      recipient,
      conversationId,
      timestamp,
      isRead);

  @override
  String toString() {
    return 'ChatMessageModel(id: $id, type: $type, content: $content, sender: $sender, senderAvatar: $senderAvatar, senderNickname: $senderNickname, recipient: $recipient, conversationId: $conversationId, timestamp: $timestamp, isRead: $isRead)';
  }
}

/// @nodoc
abstract mixin class $ChatMessageModelCopyWith<$Res> {
  factory $ChatMessageModelCopyWith(
          ChatMessageModel value, $Res Function(ChatMessageModel) _then) =
      _$ChatMessageModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(includeIfNull: false) int? id,
      @JsonKey(name: 'type') MessageType type,
      @JsonKey(includeIfNull: false) MessageContent? content,
      @JsonKey(includeIfNull: false) num? sender,
      @JsonKey(includeIfNull: false) String? senderAvatar,
      @JsonKey(includeIfNull: false) String? senderNickname,
      @JsonKey(includeIfNull: false) num? recipient,
      @JsonKey(includeIfNull: false) int? conversationId,
      int timestamp,
      @JsonKey(name: 'read') bool isRead});
}

/// @nodoc
class _$ChatMessageModelCopyWithImpl<$Res>
    implements $ChatMessageModelCopyWith<$Res> {
  _$ChatMessageModelCopyWithImpl(this._self, this._then);

  final ChatMessageModel _self;
  final $Res Function(ChatMessageModel) _then;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = null,
    Object? content = freezed,
    Object? sender = freezed,
    Object? senderAvatar = freezed,
    Object? senderNickname = freezed,
    Object? recipient = freezed,
    Object? conversationId = freezed,
    Object? timestamp = null,
    Object? isRead = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as MessageContent?,
      sender: freezed == sender
          ? _self.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as num?,
      senderAvatar: freezed == senderAvatar
          ? _self.senderAvatar
          : senderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      senderNickname: freezed == senderNickname
          ? _self.senderNickname
          : senderNickname // ignore: cast_nullable_to_non_nullable
              as String?,
      recipient: freezed == recipient
          ? _self.recipient
          : recipient // ignore: cast_nullable_to_non_nullable
              as num?,
      conversationId: freezed == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as int?,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ChatMessageModel implements ChatMessageModel {
  const _ChatMessageModel(
      {@JsonKey(includeIfNull: false) this.id,
      @JsonKey(name: 'type') required this.type,
      @JsonKey(includeIfNull: false) this.content,
      @JsonKey(includeIfNull: false) this.sender,
      @JsonKey(includeIfNull: false) this.senderAvatar,
      @JsonKey(includeIfNull: false) this.senderNickname,
      @JsonKey(includeIfNull: false) this.recipient,
      @JsonKey(includeIfNull: false) this.conversationId,
      required this.timestamp,
      @JsonKey(name: 'read') this.isRead = false});
  factory _ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  @override
  @JsonKey(includeIfNull: false)
  final int? id;
  @override
  @JsonKey(name: 'type')
  final MessageType type;
  @override
  @JsonKey(includeIfNull: false)
  final MessageContent? content;
  @override
  @JsonKey(includeIfNull: false)
  final num? sender;
  @override
  @JsonKey(includeIfNull: false)
  final String? senderAvatar;
  @override
  @JsonKey(includeIfNull: false)
  final String? senderNickname;
  @override
  @JsonKey(includeIfNull: false)
  final num? recipient;
  @override
  @JsonKey(includeIfNull: false)
  final int? conversationId;
  @override
  final int timestamp;
  @override
  @JsonKey(name: 'read')
  final bool isRead;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChatMessageModelCopyWith<_ChatMessageModel> get copyWith =>
      __$ChatMessageModelCopyWithImpl<_ChatMessageModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChatMessageModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatMessageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.senderAvatar, senderAvatar) ||
                other.senderAvatar == senderAvatar) &&
            (identical(other.senderNickname, senderNickname) ||
                other.senderNickname == senderNickname) &&
            (identical(other.recipient, recipient) ||
                other.recipient == recipient) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      content,
      sender,
      senderAvatar,
      senderNickname,
      recipient,
      conversationId,
      timestamp,
      isRead);

  @override
  String toString() {
    return 'ChatMessageModel(id: $id, type: $type, content: $content, sender: $sender, senderAvatar: $senderAvatar, senderNickname: $senderNickname, recipient: $recipient, conversationId: $conversationId, timestamp: $timestamp, isRead: $isRead)';
  }
}

/// @nodoc
abstract mixin class _$ChatMessageModelCopyWith<$Res>
    implements $ChatMessageModelCopyWith<$Res> {
  factory _$ChatMessageModelCopyWith(
          _ChatMessageModel value, $Res Function(_ChatMessageModel) _then) =
      __$ChatMessageModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(includeIfNull: false) int? id,
      @JsonKey(name: 'type') MessageType type,
      @JsonKey(includeIfNull: false) MessageContent? content,
      @JsonKey(includeIfNull: false) num? sender,
      @JsonKey(includeIfNull: false) String? senderAvatar,
      @JsonKey(includeIfNull: false) String? senderNickname,
      @JsonKey(includeIfNull: false) num? recipient,
      @JsonKey(includeIfNull: false) int? conversationId,
      int timestamp,
      @JsonKey(name: 'read') bool isRead});
}

/// @nodoc
class __$ChatMessageModelCopyWithImpl<$Res>
    implements _$ChatMessageModelCopyWith<$Res> {
  __$ChatMessageModelCopyWithImpl(this._self, this._then);

  final _ChatMessageModel _self;
  final $Res Function(_ChatMessageModel) _then;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? type = null,
    Object? content = freezed,
    Object? sender = freezed,
    Object? senderAvatar = freezed,
    Object? senderNickname = freezed,
    Object? recipient = freezed,
    Object? conversationId = freezed,
    Object? timestamp = null,
    Object? isRead = null,
  }) {
    return _then(_ChatMessageModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as MessageContent?,
      sender: freezed == sender
          ? _self.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as num?,
      senderAvatar: freezed == senderAvatar
          ? _self.senderAvatar
          : senderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      senderNickname: freezed == senderNickname
          ? _self.senderNickname
          : senderNickname // ignore: cast_nullable_to_non_nullable
              as String?,
      recipient: freezed == recipient
          ? _self.recipient
          : recipient // ignore: cast_nullable_to_non_nullable
              as num?,
      conversationId: freezed == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as int?,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      isRead: null == isRead
          ? _self.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
