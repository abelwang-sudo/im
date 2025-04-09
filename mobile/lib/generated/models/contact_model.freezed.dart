// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../models/contact_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactModel {
  /// id
  int get id;

  /// username
  String get username;

  /// email
  String get email;

  /// nickname
  String? get nickname;

  /// avatar
  String? get avatar;

  /// createdAt
  num get createdAt;

  /// updatedAt
  num get updatedAt;
  UserStatus? get status;

  /// Create a copy of ContactModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ContactModelCopyWith<ContactModel> get copyWith =>
      _$ContactModelCopyWithImpl<ContactModel>(
          this as ContactModel, _$identity);

  /// Serializes this ContactModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ContactModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, username, email, nickname,
      avatar, createdAt, updatedAt, status);

  @override
  String toString() {
    return 'ContactModel(id: $id, username: $username, email: $email, nickname: $nickname, avatar: $avatar, createdAt: $createdAt, updatedAt: $updatedAt, status: $status)';
  }
}

/// @nodoc
abstract mixin class $ContactModelCopyWith<$Res> {
  factory $ContactModelCopyWith(
          ContactModel value, $Res Function(ContactModel) _then) =
      _$ContactModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String username,
      String email,
      String? nickname,
      String? avatar,
      num createdAt,
      num updatedAt,
      UserStatus? status});
}

/// @nodoc
class _$ContactModelCopyWithImpl<$Res> implements $ContactModelCopyWith<$Res> {
  _$ContactModelCopyWithImpl(this._self, this._then);

  final ContactModel _self;
  final $Res Function(ContactModel) _then;

  /// Create a copy of ContactModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? nickname = freezed,
    Object? avatar = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? status = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as num,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as num,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ContactModel implements ContactModel {
  const _ContactModel(
      {required this.id,
      required this.username,
      required this.email,
      this.nickname,
      this.avatar,
      required this.createdAt,
      required this.updatedAt,
      this.status});
  factory _ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  /// id
  @override
  final int id;

  /// username
  @override
  final String username;

  /// email
  @override
  final String email;

  /// nickname
  @override
  final String? nickname;

  /// avatar
  @override
  final String? avatar;

  /// createdAt
  @override
  final num createdAt;

  /// updatedAt
  @override
  final num updatedAt;
  @override
  final UserStatus? status;

  /// Create a copy of ContactModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ContactModelCopyWith<_ContactModel> get copyWith =>
      __$ContactModelCopyWithImpl<_ContactModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ContactModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ContactModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, username, email, nickname,
      avatar, createdAt, updatedAt, status);

  @override
  String toString() {
    return 'ContactModel(id: $id, username: $username, email: $email, nickname: $nickname, avatar: $avatar, createdAt: $createdAt, updatedAt: $updatedAt, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$ContactModelCopyWith<$Res>
    implements $ContactModelCopyWith<$Res> {
  factory _$ContactModelCopyWith(
          _ContactModel value, $Res Function(_ContactModel) _then) =
      __$ContactModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String username,
      String email,
      String? nickname,
      String? avatar,
      num createdAt,
      num updatedAt,
      UserStatus? status});
}

/// @nodoc
class __$ContactModelCopyWithImpl<$Res>
    implements _$ContactModelCopyWith<$Res> {
  __$ContactModelCopyWithImpl(this._self, this._then);

  final _ContactModel _self;
  final $Res Function(_ContactModel) _then;

  /// Create a copy of ContactModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? nickname = freezed,
    Object? avatar = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? status = freezed,
  }) {
    return _then(_ContactModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as num,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as num,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus?,
    ));
  }
}

// dart format on
