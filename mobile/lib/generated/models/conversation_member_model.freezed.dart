// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../models/conversation_member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationMemberModel {
  /// id
  int get id;

  /// conversationId
  int get conversationId;

  /// userId
  int get userId;

  /// nickname
  String? get nickname;

  /// displayName
  String? get displayName;

  /// avatar
  String? get avatar;
  String? get role;

  /// unreadCount
  int get unreadCount;

  /// createdAt
  int get createdAt;

  /// updatedAt
  int get updatedAt;

  /// Create a copy of ConversationMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConversationMemberModelCopyWith<ConversationMemberModel> get copyWith =>
      _$ConversationMemberModelCopyWithImpl<ConversationMemberModel>(
          this as ConversationMemberModel, _$identity);

  /// Serializes this ConversationMemberModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConversationMemberModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, conversationId, userId,
      nickname, displayName, avatar, role, unreadCount, createdAt, updatedAt);

  @override
  String toString() {
    return 'ConversationMemberModel(id: $id, conversationId: $conversationId, userId: $userId, nickname: $nickname, displayName: $displayName, avatar: $avatar, role: $role, unreadCount: $unreadCount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ConversationMemberModelCopyWith<$Res> {
  factory $ConversationMemberModelCopyWith(ConversationMemberModel value,
          $Res Function(ConversationMemberModel) _then) =
      _$ConversationMemberModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int conversationId,
      int userId,
      String? nickname,
      String? displayName,
      String? avatar,
      String? role,
      int unreadCount,
      int createdAt,
      int updatedAt});
}

/// @nodoc
class _$ConversationMemberModelCopyWithImpl<$Res>
    implements $ConversationMemberModelCopyWith<$Res> {
  _$ConversationMemberModelCopyWithImpl(this._self, this._then);

  final ConversationMemberModel _self;
  final $Res Function(ConversationMemberModel) _then;

  /// Create a copy of ConversationMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? userId = null,
    Object? nickname = freezed,
    Object? displayName = freezed,
    Object? avatar = freezed,
    Object? role = freezed,
    Object? unreadCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      unreadCount: null == unreadCount
          ? _self.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ConversationMemberModel extends ConversationMemberModel {
  const _ConversationMemberModel(
      {required this.id,
      required this.conversationId,
      required this.userId,
      required this.nickname,
      required this.displayName,
      this.avatar,
      this.role,
      required this.unreadCount,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  factory _ConversationMemberModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationMemberModelFromJson(json);

  /// id
  @override
  final int id;

  /// conversationId
  @override
  final int conversationId;

  /// userId
  @override
  final int userId;

  /// nickname
  @override
  final String? nickname;

  /// displayName
  @override
  final String? displayName;

  /// avatar
  @override
  final String? avatar;
  @override
  final String? role;

  /// unreadCount
  @override
  final int unreadCount;

  /// createdAt
  @override
  final int createdAt;

  /// updatedAt
  @override
  final int updatedAt;

  /// Create a copy of ConversationMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConversationMemberModelCopyWith<_ConversationMemberModel> get copyWith =>
      __$ConversationMemberModelCopyWithImpl<_ConversationMemberModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConversationMemberModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConversationMemberModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, conversationId, userId,
      nickname, displayName, avatar, role, unreadCount, createdAt, updatedAt);

  @override
  String toString() {
    return 'ConversationMemberModel(id: $id, conversationId: $conversationId, userId: $userId, nickname: $nickname, displayName: $displayName, avatar: $avatar, role: $role, unreadCount: $unreadCount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$ConversationMemberModelCopyWith<$Res>
    implements $ConversationMemberModelCopyWith<$Res> {
  factory _$ConversationMemberModelCopyWith(_ConversationMemberModel value,
          $Res Function(_ConversationMemberModel) _then) =
      __$ConversationMemberModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int conversationId,
      int userId,
      String? nickname,
      String? displayName,
      String? avatar,
      String? role,
      int unreadCount,
      int createdAt,
      int updatedAt});
}

/// @nodoc
class __$ConversationMemberModelCopyWithImpl<$Res>
    implements _$ConversationMemberModelCopyWith<$Res> {
  __$ConversationMemberModelCopyWithImpl(this._self, this._then);

  final _ConversationMemberModel _self;
  final $Res Function(_ConversationMemberModel) _then;

  /// Create a copy of ConversationMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? userId = null,
    Object? nickname = freezed,
    Object? displayName = freezed,
    Object? avatar = freezed,
    Object? role = freezed,
    Object? unreadCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_ConversationMemberModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      unreadCount: null == unreadCount
          ? _self.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
