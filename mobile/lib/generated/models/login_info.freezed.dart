// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../models/login_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginInfo {
  int get id;
  String? get avatar;
  String get token;
  String get username;
  String? get nickname;
  String get email;

  /// Create a copy of LoginInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoginInfoCopyWith<LoginInfo> get copyWith =>
      _$LoginInfoCopyWithImpl<LoginInfo>(this as LoginInfo, _$identity);

  /// Serializes this LoginInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoginInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, avatar, token, username, nickname, email);

  @override
  String toString() {
    return 'LoginInfo(id: $id, avatar: $avatar, token: $token, username: $username, nickname: $nickname, email: $email)';
  }
}

/// @nodoc
abstract mixin class $LoginInfoCopyWith<$Res> {
  factory $LoginInfoCopyWith(LoginInfo value, $Res Function(LoginInfo) _then) =
      _$LoginInfoCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String? avatar,
      String token,
      String username,
      String? nickname,
      String email});
}

/// @nodoc
class _$LoginInfoCopyWithImpl<$Res> implements $LoginInfoCopyWith<$Res> {
  _$LoginInfoCopyWithImpl(this._self, this._then);

  final LoginInfo _self;
  final $Res Function(LoginInfo) _then;

  /// Create a copy of LoginInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? avatar = freezed,
    Object? token = null,
    Object? username = null,
    Object? nickname = freezed,
    Object? email = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _LoginInfo implements LoginInfo {
  const _LoginInfo(
      {required this.id,
      this.avatar,
      required this.token,
      required this.username,
      this.nickname,
      required this.email});
  factory _LoginInfo.fromJson(Map<String, dynamic> json) =>
      _$LoginInfoFromJson(json);

  @override
  final int id;
  @override
  final String? avatar;
  @override
  final String token;
  @override
  final String username;
  @override
  final String? nickname;
  @override
  final String email;

  /// Create a copy of LoginInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoginInfoCopyWith<_LoginInfo> get copyWith =>
      __$LoginInfoCopyWithImpl<_LoginInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LoginInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoginInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, avatar, token, username, nickname, email);

  @override
  String toString() {
    return 'LoginInfo(id: $id, avatar: $avatar, token: $token, username: $username, nickname: $nickname, email: $email)';
  }
}

/// @nodoc
abstract mixin class _$LoginInfoCopyWith<$Res>
    implements $LoginInfoCopyWith<$Res> {
  factory _$LoginInfoCopyWith(
          _LoginInfo value, $Res Function(_LoginInfo) _then) =
      __$LoginInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String? avatar,
      String token,
      String username,
      String? nickname,
      String email});
}

/// @nodoc
class __$LoginInfoCopyWithImpl<$Res> implements _$LoginInfoCopyWith<$Res> {
  __$LoginInfoCopyWithImpl(this._self, this._then);

  final _LoginInfo _self;
  final $Res Function(_LoginInfo) _then;

  /// Create a copy of LoginInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? avatar = freezed,
    Object? token = null,
    Object? username = null,
    Object? nickname = freezed,
    Object? email = null,
  }) {
    return _then(_LoginInfo(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
