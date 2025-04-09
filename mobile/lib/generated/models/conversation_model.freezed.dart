// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../models/conversation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationModel {
  /// 会话ID
  int get id;

  /// 会话类型：单聊或群聊
  @JsonKey(name: 'type')
  String get type;

  /// 会话名称
  @JsonKey(name: 'name')
  String? get name;

  /// 会话头像
  @JsonKey(name: 'avatar')
  String? get avatar;
  ChatMessageModel? get lastMessage;
  int? get createdAt;
  int? get updatedAt;
  ConversationMemberModel? get member;
  GroupModel? get group;
  bool get requireApproval;
  bool get onlyAdminCanInvite;
  bool get onlyAdminCanSpeak;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConversationModelCopyWith<ConversationModel> get copyWith =>
      _$ConversationModelCopyWithImpl<ConversationModel>(
          this as ConversationModel, _$identity);

  /// Serializes this ConversationModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConversationModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.requireApproval, requireApproval) ||
                other.requireApproval == requireApproval) &&
            (identical(other.onlyAdminCanInvite, onlyAdminCanInvite) ||
                other.onlyAdminCanInvite == onlyAdminCanInvite) &&
            (identical(other.onlyAdminCanSpeak, onlyAdminCanSpeak) ||
                other.onlyAdminCanSpeak == onlyAdminCanSpeak));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      name,
      avatar,
      lastMessage,
      createdAt,
      updatedAt,
      member,
      group,
      requireApproval,
      onlyAdminCanInvite,
      onlyAdminCanSpeak);

  @override
  String toString() {
    return 'ConversationModel(id: $id, type: $type, name: $name, avatar: $avatar, lastMessage: $lastMessage, createdAt: $createdAt, updatedAt: $updatedAt, member: $member, group: $group, requireApproval: $requireApproval, onlyAdminCanInvite: $onlyAdminCanInvite, onlyAdminCanSpeak: $onlyAdminCanSpeak)';
  }
}

/// @nodoc
abstract mixin class $ConversationModelCopyWith<$Res> {
  factory $ConversationModelCopyWith(
          ConversationModel value, $Res Function(ConversationModel) _then) =
      _$ConversationModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'type') String type,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'avatar') String? avatar,
      ChatMessageModel? lastMessage,
      int? createdAt,
      int? updatedAt,
      ConversationMemberModel? member,
      GroupModel? group,
      bool requireApproval,
      bool onlyAdminCanInvite,
      bool onlyAdminCanSpeak});

  $ChatMessageModelCopyWith<$Res>? get lastMessage;
  $ConversationMemberModelCopyWith<$Res>? get member;
  $GroupModelCopyWith<$Res>? get group;
}

/// @nodoc
class _$ConversationModelCopyWithImpl<$Res>
    implements $ConversationModelCopyWith<$Res> {
  _$ConversationModelCopyWithImpl(this._self, this._then);

  final ConversationModel _self;
  final $Res Function(ConversationModel) _then;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = freezed,
    Object? avatar = freezed,
    Object? lastMessage = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? member = freezed,
    Object? group = freezed,
    Object? requireApproval = null,
    Object? onlyAdminCanInvite = null,
    Object? onlyAdminCanSpeak = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessage: freezed == lastMessage
          ? _self.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as ChatMessageModel?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int?,
      member: freezed == member
          ? _self.member
          : member // ignore: cast_nullable_to_non_nullable
              as ConversationMemberModel?,
      group: freezed == group
          ? _self.group
          : group // ignore: cast_nullable_to_non_nullable
              as GroupModel?,
      requireApproval: null == requireApproval
          ? _self.requireApproval
          : requireApproval // ignore: cast_nullable_to_non_nullable
              as bool,
      onlyAdminCanInvite: null == onlyAdminCanInvite
          ? _self.onlyAdminCanInvite
          : onlyAdminCanInvite // ignore: cast_nullable_to_non_nullable
              as bool,
      onlyAdminCanSpeak: null == onlyAdminCanSpeak
          ? _self.onlyAdminCanSpeak
          : onlyAdminCanSpeak // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageModelCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
      return null;
    }

    return $ChatMessageModelCopyWith<$Res>(_self.lastMessage!, (value) {
      return _then(_self.copyWith(lastMessage: value));
    });
  }

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversationMemberModelCopyWith<$Res>? get member {
    if (_self.member == null) {
      return null;
    }

    return $ConversationMemberModelCopyWith<$Res>(_self.member!, (value) {
      return _then(_self.copyWith(member: value));
    });
  }

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupModelCopyWith<$Res>? get group {
    if (_self.group == null) {
      return null;
    }

    return $GroupModelCopyWith<$Res>(_self.group!, (value) {
      return _then(_self.copyWith(group: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _ConversationModel extends ConversationModel {
  const _ConversationModel(
      {required this.id,
      @JsonKey(name: 'type') required this.type,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'avatar') this.avatar,
      this.lastMessage,
      this.createdAt,
      this.updatedAt,
      this.member,
      this.group,
      this.requireApproval = false,
      this.onlyAdminCanInvite = false,
      this.onlyAdminCanSpeak = false})
      : super._();
  factory _ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  /// 会话ID
  @override
  final int id;

  /// 会话类型：单聊或群聊
  @override
  @JsonKey(name: 'type')
  final String type;

  /// 会话名称
  @override
  @JsonKey(name: 'name')
  final String? name;

  /// 会话头像
  @override
  @JsonKey(name: 'avatar')
  final String? avatar;
  @override
  final ChatMessageModel? lastMessage;
  @override
  final int? createdAt;
  @override
  final int? updatedAt;
  @override
  final ConversationMemberModel? member;
  @override
  final GroupModel? group;
  @override
  @JsonKey()
  final bool requireApproval;
  @override
  @JsonKey()
  final bool onlyAdminCanInvite;
  @override
  @JsonKey()
  final bool onlyAdminCanSpeak;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConversationModelCopyWith<_ConversationModel> get copyWith =>
      __$ConversationModelCopyWithImpl<_ConversationModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConversationModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConversationModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.requireApproval, requireApproval) ||
                other.requireApproval == requireApproval) &&
            (identical(other.onlyAdminCanInvite, onlyAdminCanInvite) ||
                other.onlyAdminCanInvite == onlyAdminCanInvite) &&
            (identical(other.onlyAdminCanSpeak, onlyAdminCanSpeak) ||
                other.onlyAdminCanSpeak == onlyAdminCanSpeak));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      name,
      avatar,
      lastMessage,
      createdAt,
      updatedAt,
      member,
      group,
      requireApproval,
      onlyAdminCanInvite,
      onlyAdminCanSpeak);

  @override
  String toString() {
    return 'ConversationModel(id: $id, type: $type, name: $name, avatar: $avatar, lastMessage: $lastMessage, createdAt: $createdAt, updatedAt: $updatedAt, member: $member, group: $group, requireApproval: $requireApproval, onlyAdminCanInvite: $onlyAdminCanInvite, onlyAdminCanSpeak: $onlyAdminCanSpeak)';
  }
}

/// @nodoc
abstract mixin class _$ConversationModelCopyWith<$Res>
    implements $ConversationModelCopyWith<$Res> {
  factory _$ConversationModelCopyWith(
          _ConversationModel value, $Res Function(_ConversationModel) _then) =
      __$ConversationModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'type') String type,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'avatar') String? avatar,
      ChatMessageModel? lastMessage,
      int? createdAt,
      int? updatedAt,
      ConversationMemberModel? member,
      GroupModel? group,
      bool requireApproval,
      bool onlyAdminCanInvite,
      bool onlyAdminCanSpeak});

  @override
  $ChatMessageModelCopyWith<$Res>? get lastMessage;
  @override
  $ConversationMemberModelCopyWith<$Res>? get member;
  @override
  $GroupModelCopyWith<$Res>? get group;
}

/// @nodoc
class __$ConversationModelCopyWithImpl<$Res>
    implements _$ConversationModelCopyWith<$Res> {
  __$ConversationModelCopyWithImpl(this._self, this._then);

  final _ConversationModel _self;
  final $Res Function(_ConversationModel) _then;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = freezed,
    Object? avatar = freezed,
    Object? lastMessage = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? member = freezed,
    Object? group = freezed,
    Object? requireApproval = null,
    Object? onlyAdminCanInvite = null,
    Object? onlyAdminCanSpeak = null,
  }) {
    return _then(_ConversationModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessage: freezed == lastMessage
          ? _self.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as ChatMessageModel?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int?,
      member: freezed == member
          ? _self.member
          : member // ignore: cast_nullable_to_non_nullable
              as ConversationMemberModel?,
      group: freezed == group
          ? _self.group
          : group // ignore: cast_nullable_to_non_nullable
              as GroupModel?,
      requireApproval: null == requireApproval
          ? _self.requireApproval
          : requireApproval // ignore: cast_nullable_to_non_nullable
              as bool,
      onlyAdminCanInvite: null == onlyAdminCanInvite
          ? _self.onlyAdminCanInvite
          : onlyAdminCanInvite // ignore: cast_nullable_to_non_nullable
              as bool,
      onlyAdminCanSpeak: null == onlyAdminCanSpeak
          ? _self.onlyAdminCanSpeak
          : onlyAdminCanSpeak // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageModelCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
      return null;
    }

    return $ChatMessageModelCopyWith<$Res>(_self.lastMessage!, (value) {
      return _then(_self.copyWith(lastMessage: value));
    });
  }

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversationMemberModelCopyWith<$Res>? get member {
    if (_self.member == null) {
      return null;
    }

    return $ConversationMemberModelCopyWith<$Res>(_self.member!, (value) {
      return _then(_self.copyWith(member: value));
    });
  }

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupModelCopyWith<$Res>? get group {
    if (_self.group == null) {
      return null;
    }

    return $GroupModelCopyWith<$Res>(_self.group!, (value) {
      return _then(_self.copyWith(group: value));
    });
  }
}

// dart format on
