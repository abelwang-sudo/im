// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../models/friendship_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FriendshipModel {
  int get id;
  int? get requesterId;
  int? get addresseeId;
  String get status; // PENDING, ACCEPTED, REJECTED
  num get createdAt;
  num? get updatedAt;
  ContactModel? get requester;
  ContactModel? get addressee;

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FriendshipModelCopyWith<FriendshipModel> get copyWith =>
      _$FriendshipModelCopyWithImpl<FriendshipModel>(
          this as FriendshipModel, _$identity);

  /// Serializes this FriendshipModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FriendshipModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId) &&
            (identical(other.addresseeId, addresseeId) ||
                other.addresseeId == addresseeId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.requester, requester) ||
                other.requester == requester) &&
            (identical(other.addressee, addressee) ||
                other.addressee == addressee));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, requesterId, addresseeId,
      status, createdAt, updatedAt, requester, addressee);

  @override
  String toString() {
    return 'FriendshipModel(id: $id, requesterId: $requesterId, addresseeId: $addresseeId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, requester: $requester, addressee: $addressee)';
  }
}

/// @nodoc
abstract mixin class $FriendshipModelCopyWith<$Res> {
  factory $FriendshipModelCopyWith(
          FriendshipModel value, $Res Function(FriendshipModel) _then) =
      _$FriendshipModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int? requesterId,
      int? addresseeId,
      String status,
      num createdAt,
      num? updatedAt,
      ContactModel? requester,
      ContactModel? addressee});

  $ContactModelCopyWith<$Res>? get requester;
  $ContactModelCopyWith<$Res>? get addressee;
}

/// @nodoc
class _$FriendshipModelCopyWithImpl<$Res>
    implements $FriendshipModelCopyWith<$Res> {
  _$FriendshipModelCopyWithImpl(this._self, this._then);

  final FriendshipModel _self;
  final $Res Function(FriendshipModel) _then;

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = freezed,
    Object? addresseeId = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? requester = freezed,
    Object? addressee = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      requesterId: freezed == requesterId
          ? _self.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as int?,
      addresseeId: freezed == addresseeId
          ? _self.addresseeId
          : addresseeId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as num,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as num?,
      requester: freezed == requester
          ? _self.requester
          : requester // ignore: cast_nullable_to_non_nullable
              as ContactModel?,
      addressee: freezed == addressee
          ? _self.addressee
          : addressee // ignore: cast_nullable_to_non_nullable
              as ContactModel?,
    ));
  }

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactModelCopyWith<$Res>? get requester {
    if (_self.requester == null) {
      return null;
    }

    return $ContactModelCopyWith<$Res>(_self.requester!, (value) {
      return _then(_self.copyWith(requester: value));
    });
  }

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactModelCopyWith<$Res>? get addressee {
    if (_self.addressee == null) {
      return null;
    }

    return $ContactModelCopyWith<$Res>(_self.addressee!, (value) {
      return _then(_self.copyWith(addressee: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _FriendshipModel implements FriendshipModel {
  const _FriendshipModel(
      {required this.id,
      this.requesterId,
      this.addresseeId,
      required this.status,
      required this.createdAt,
      this.updatedAt,
      this.requester,
      this.addressee});
  factory _FriendshipModel.fromJson(Map<String, dynamic> json) =>
      _$FriendshipModelFromJson(json);

  @override
  final int id;
  @override
  final int? requesterId;
  @override
  final int? addresseeId;
  @override
  final String status;
// PENDING, ACCEPTED, REJECTED
  @override
  final num createdAt;
  @override
  final num? updatedAt;
  @override
  final ContactModel? requester;
  @override
  final ContactModel? addressee;

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FriendshipModelCopyWith<_FriendshipModel> get copyWith =>
      __$FriendshipModelCopyWithImpl<_FriendshipModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FriendshipModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FriendshipModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId) &&
            (identical(other.addresseeId, addresseeId) ||
                other.addresseeId == addresseeId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.requester, requester) ||
                other.requester == requester) &&
            (identical(other.addressee, addressee) ||
                other.addressee == addressee));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, requesterId, addresseeId,
      status, createdAt, updatedAt, requester, addressee);

  @override
  String toString() {
    return 'FriendshipModel(id: $id, requesterId: $requesterId, addresseeId: $addresseeId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, requester: $requester, addressee: $addressee)';
  }
}

/// @nodoc
abstract mixin class _$FriendshipModelCopyWith<$Res>
    implements $FriendshipModelCopyWith<$Res> {
  factory _$FriendshipModelCopyWith(
          _FriendshipModel value, $Res Function(_FriendshipModel) _then) =
      __$FriendshipModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int? requesterId,
      int? addresseeId,
      String status,
      num createdAt,
      num? updatedAt,
      ContactModel? requester,
      ContactModel? addressee});

  @override
  $ContactModelCopyWith<$Res>? get requester;
  @override
  $ContactModelCopyWith<$Res>? get addressee;
}

/// @nodoc
class __$FriendshipModelCopyWithImpl<$Res>
    implements _$FriendshipModelCopyWith<$Res> {
  __$FriendshipModelCopyWithImpl(this._self, this._then);

  final _FriendshipModel _self;
  final $Res Function(_FriendshipModel) _then;

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? requesterId = freezed,
    Object? addresseeId = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? requester = freezed,
    Object? addressee = freezed,
  }) {
    return _then(_FriendshipModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      requesterId: freezed == requesterId
          ? _self.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as int?,
      addresseeId: freezed == addresseeId
          ? _self.addresseeId
          : addresseeId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as num,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as num?,
      requester: freezed == requester
          ? _self.requester
          : requester // ignore: cast_nullable_to_non_nullable
              as ContactModel?,
      addressee: freezed == addressee
          ? _self.addressee
          : addressee // ignore: cast_nullable_to_non_nullable
              as ContactModel?,
    ));
  }

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactModelCopyWith<$Res>? get requester {
    if (_self.requester == null) {
      return null;
    }

    return $ContactModelCopyWith<$Res>(_self.requester!, (value) {
      return _then(_self.copyWith(requester: value));
    });
  }

  /// Create a copy of FriendshipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactModelCopyWith<$Res>? get addressee {
    if (_self.addressee == null) {
      return null;
    }

    return $ContactModelCopyWith<$Res>(_self.addressee!, (value) {
      return _then(_self.copyWith(addressee: value));
    });
  }
}

// dart format on
