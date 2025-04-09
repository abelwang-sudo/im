// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../models/group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupOwnerModel {
  int get id;
  String get username;
  String get email;
  String? get nickname;
  String? get avatar;
  int get createdAt;
  int get updatedAt;
  @JsonKey(includeIfNull: false)
  String? get password;

  /// Create a copy of GroupOwnerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupOwnerModelCopyWith<GroupOwnerModel> get copyWith =>
      _$GroupOwnerModelCopyWithImpl<GroupOwnerModel>(
          this as GroupOwnerModel, _$identity);

  /// Serializes this GroupOwnerModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupOwnerModel &&
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
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, username, email, nickname,
      avatar, createdAt, updatedAt, password);

  @override
  String toString() {
    return 'GroupOwnerModel(id: $id, username: $username, email: $email, nickname: $nickname, avatar: $avatar, createdAt: $createdAt, updatedAt: $updatedAt, password: $password)';
  }
}

/// @nodoc
abstract mixin class $GroupOwnerModelCopyWith<$Res> {
  factory $GroupOwnerModelCopyWith(
          GroupOwnerModel value, $Res Function(GroupOwnerModel) _then) =
      _$GroupOwnerModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String username,
      String email,
      String? nickname,
      String? avatar,
      int createdAt,
      int updatedAt,
      @JsonKey(includeIfNull: false) String? password});
}

/// @nodoc
class _$GroupOwnerModelCopyWithImpl<$Res>
    implements $GroupOwnerModelCopyWith<$Res> {
  _$GroupOwnerModelCopyWithImpl(this._self, this._then);

  final GroupOwnerModel _self;
  final $Res Function(GroupOwnerModel) _then;

  /// Create a copy of GroupOwnerModel
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
    Object? password = freezed,
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
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      password: freezed == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _GroupOwnerModel implements GroupOwnerModel {
  const _GroupOwnerModel(
      {required this.id,
      required this.username,
      required this.email,
      this.nickname,
      this.avatar,
      required this.createdAt,
      required this.updatedAt,
      @JsonKey(includeIfNull: false) this.password});
  factory _GroupOwnerModel.fromJson(Map<String, dynamic> json) =>
      _$GroupOwnerModelFromJson(json);

  @override
  final int id;
  @override
  final String username;
  @override
  final String email;
  @override
  final String? nickname;
  @override
  final String? avatar;
  @override
  final int createdAt;
  @override
  final int updatedAt;
  @override
  @JsonKey(includeIfNull: false)
  final String? password;

  /// Create a copy of GroupOwnerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GroupOwnerModelCopyWith<_GroupOwnerModel> get copyWith =>
      __$GroupOwnerModelCopyWithImpl<_GroupOwnerModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GroupOwnerModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GroupOwnerModel &&
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
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, username, email, nickname,
      avatar, createdAt, updatedAt, password);

  @override
  String toString() {
    return 'GroupOwnerModel(id: $id, username: $username, email: $email, nickname: $nickname, avatar: $avatar, createdAt: $createdAt, updatedAt: $updatedAt, password: $password)';
  }
}

/// @nodoc
abstract mixin class _$GroupOwnerModelCopyWith<$Res>
    implements $GroupOwnerModelCopyWith<$Res> {
  factory _$GroupOwnerModelCopyWith(
          _GroupOwnerModel value, $Res Function(_GroupOwnerModel) _then) =
      __$GroupOwnerModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String username,
      String email,
      String? nickname,
      String? avatar,
      int createdAt,
      int updatedAt,
      @JsonKey(includeIfNull: false) String? password});
}

/// @nodoc
class __$GroupOwnerModelCopyWithImpl<$Res>
    implements _$GroupOwnerModelCopyWith<$Res> {
  __$GroupOwnerModelCopyWithImpl(this._self, this._then);

  final _GroupOwnerModel _self;
  final $Res Function(_GroupOwnerModel) _then;

  /// Create a copy of GroupOwnerModel
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
    Object? password = freezed,
  }) {
    return _then(_GroupOwnerModel(
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
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      password: freezed == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$GroupModel {
  int get id;
  int get conversationId;
  String get name;
  String? get description;
  String? get avatar;
  GroupOwnerModel? get owner;

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupModelCopyWith<GroupModel> get copyWith =>
      _$GroupModelCopyWithImpl<GroupModel>(this as GroupModel, _$identity);

  /// Serializes this GroupModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.owner, owner) || other.owner == owner));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, conversationId, name, description, avatar, owner);

  @override
  String toString() {
    return 'GroupModel(id: $id, conversationId: $conversationId, name: $name, description: $description, avatar: $avatar, owner: $owner)';
  }
}

/// @nodoc
abstract mixin class $GroupModelCopyWith<$Res> {
  factory $GroupModelCopyWith(
          GroupModel value, $Res Function(GroupModel) _then) =
      _$GroupModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int conversationId,
      String name,
      String? description,
      String? avatar,
      GroupOwnerModel? owner});

  $GroupOwnerModelCopyWith<$Res>? get owner;
}

/// @nodoc
class _$GroupModelCopyWithImpl<$Res> implements $GroupModelCopyWith<$Res> {
  _$GroupModelCopyWithImpl(this._self, this._then);

  final GroupModel _self;
  final $Res Function(GroupModel) _then;

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? name = null,
    Object? description = freezed,
    Object? avatar = freezed,
    Object? owner = freezed,
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
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      owner: freezed == owner
          ? _self.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as GroupOwnerModel?,
    ));
  }

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupOwnerModelCopyWith<$Res>? get owner {
    if (_self.owner == null) {
      return null;
    }

    return $GroupOwnerModelCopyWith<$Res>(_self.owner!, (value) {
      return _then(_self.copyWith(owner: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _GroupModel implements GroupModel {
  const _GroupModel(
      {required this.id,
      required this.conversationId,
      required this.name,
      this.description,
      this.avatar,
      this.owner});
  factory _GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  @override
  final int id;
  @override
  final int conversationId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? avatar;
  @override
  final GroupOwnerModel? owner;

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GroupModelCopyWith<_GroupModel> get copyWith =>
      __$GroupModelCopyWithImpl<_GroupModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GroupModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GroupModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.owner, owner) || other.owner == owner));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, conversationId, name, description, avatar, owner);

  @override
  String toString() {
    return 'GroupModel(id: $id, conversationId: $conversationId, name: $name, description: $description, avatar: $avatar, owner: $owner)';
  }
}

/// @nodoc
abstract mixin class _$GroupModelCopyWith<$Res>
    implements $GroupModelCopyWith<$Res> {
  factory _$GroupModelCopyWith(
          _GroupModel value, $Res Function(_GroupModel) _then) =
      __$GroupModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int conversationId,
      String name,
      String? description,
      String? avatar,
      GroupOwnerModel? owner});

  @override
  $GroupOwnerModelCopyWith<$Res>? get owner;
}

/// @nodoc
class __$GroupModelCopyWithImpl<$Res> implements _$GroupModelCopyWith<$Res> {
  __$GroupModelCopyWithImpl(this._self, this._then);

  final _GroupModel _self;
  final $Res Function(_GroupModel) _then;

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? name = null,
    Object? description = freezed,
    Object? avatar = freezed,
    Object? owner = freezed,
  }) {
    return _then(_GroupModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      owner: freezed == owner
          ? _self.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as GroupOwnerModel?,
    ));
  }

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupOwnerModelCopyWith<$Res>? get owner {
    if (_self.owner == null) {
      return null;
    }

    return $GroupOwnerModelCopyWith<$Res>(_self.owner!, (value) {
      return _then(_self.copyWith(owner: value));
    });
  }
}

// dart format on
