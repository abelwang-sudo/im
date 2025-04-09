// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../models/join_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JoinRequestModel {
  /// 申请ID
  int get id;

  /// 申请用户信息
  @JsonKey(name: 'applicant')
  UserModel? get applicant;

  /// 会话ID
  @JsonKey(name: 'conversationId')
  int get conversationId;

  /// 申请理由
  @JsonKey(name: 'reason')
  String? get reason;

  /// 申请状态：PENDING, APPROVED, REJECTED
  @JsonKey(name: 'status')
  String get status;

  /// 创建时间
  @JsonKey(name: 'createdAt')
  int? get createdAt;

  /// 更新时间
  @JsonKey(name: 'updatedAt')
  int? get updatedAt;

  /// Create a copy of JoinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $JoinRequestModelCopyWith<JoinRequestModel> get copyWith =>
      _$JoinRequestModelCopyWithImpl<JoinRequestModel>(
          this as JoinRequestModel, _$identity);

  /// Serializes this JoinRequestModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is JoinRequestModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.applicant, applicant) ||
                other.applicant == applicant) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, applicant, conversationId,
      reason, status, createdAt, updatedAt);

  @override
  String toString() {
    return 'JoinRequestModel(id: $id, applicant: $applicant, conversationId: $conversationId, reason: $reason, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $JoinRequestModelCopyWith<$Res> {
  factory $JoinRequestModelCopyWith(
          JoinRequestModel value, $Res Function(JoinRequestModel) _then) =
      _$JoinRequestModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'applicant') UserModel? applicant,
      @JsonKey(name: 'conversationId') int conversationId,
      @JsonKey(name: 'reason') String? reason,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'createdAt') int? createdAt,
      @JsonKey(name: 'updatedAt') int? updatedAt});

  $UserModelCopyWith<$Res>? get applicant;
}

/// @nodoc
class _$JoinRequestModelCopyWithImpl<$Res>
    implements $JoinRequestModelCopyWith<$Res> {
  _$JoinRequestModelCopyWithImpl(this._self, this._then);

  final JoinRequestModel _self;
  final $Res Function(JoinRequestModel) _then;

  /// Create a copy of JoinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? applicant = freezed,
    Object? conversationId = null,
    Object? reason = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      applicant: freezed == applicant
          ? _self.applicant
          : applicant // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as int,
      reason: freezed == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of JoinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get applicant {
    if (_self.applicant == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_self.applicant!, (value) {
      return _then(_self.copyWith(applicant: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _JoinRequestModel implements JoinRequestModel {
  const _JoinRequestModel(
      {required this.id,
      @JsonKey(name: 'applicant') this.applicant,
      @JsonKey(name: 'conversationId') required this.conversationId,
      @JsonKey(name: 'reason') this.reason,
      @JsonKey(name: 'status') required this.status,
      @JsonKey(name: 'createdAt') this.createdAt,
      @JsonKey(name: 'updatedAt') this.updatedAt});
  factory _JoinRequestModel.fromJson(Map<String, dynamic> json) =>
      _$JoinRequestModelFromJson(json);

  /// 申请ID
  @override
  final int id;

  /// 申请用户信息
  @override
  @JsonKey(name: 'applicant')
  final UserModel? applicant;

  /// 会话ID
  @override
  @JsonKey(name: 'conversationId')
  final int conversationId;

  /// 申请理由
  @override
  @JsonKey(name: 'reason')
  final String? reason;

  /// 申请状态：PENDING, APPROVED, REJECTED
  @override
  @JsonKey(name: 'status')
  final String status;

  /// 创建时间
  @override
  @JsonKey(name: 'createdAt')
  final int? createdAt;

  /// 更新时间
  @override
  @JsonKey(name: 'updatedAt')
  final int? updatedAt;

  /// Create a copy of JoinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$JoinRequestModelCopyWith<_JoinRequestModel> get copyWith =>
      __$JoinRequestModelCopyWithImpl<_JoinRequestModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$JoinRequestModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _JoinRequestModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.applicant, applicant) ||
                other.applicant == applicant) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, applicant, conversationId,
      reason, status, createdAt, updatedAt);

  @override
  String toString() {
    return 'JoinRequestModel(id: $id, applicant: $applicant, conversationId: $conversationId, reason: $reason, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$JoinRequestModelCopyWith<$Res>
    implements $JoinRequestModelCopyWith<$Res> {
  factory _$JoinRequestModelCopyWith(
          _JoinRequestModel value, $Res Function(_JoinRequestModel) _then) =
      __$JoinRequestModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'applicant') UserModel? applicant,
      @JsonKey(name: 'conversationId') int conversationId,
      @JsonKey(name: 'reason') String? reason,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'createdAt') int? createdAt,
      @JsonKey(name: 'updatedAt') int? updatedAt});

  @override
  $UserModelCopyWith<$Res>? get applicant;
}

/// @nodoc
class __$JoinRequestModelCopyWithImpl<$Res>
    implements _$JoinRequestModelCopyWith<$Res> {
  __$JoinRequestModelCopyWithImpl(this._self, this._then);

  final _JoinRequestModel _self;
  final $Res Function(_JoinRequestModel) _then;

  /// Create a copy of JoinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? applicant = freezed,
    Object? conversationId = null,
    Object? reason = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_JoinRequestModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      applicant: freezed == applicant
          ? _self.applicant
          : applicant // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as int,
      reason: freezed == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of JoinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get applicant {
    if (_self.applicant == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_self.applicant!, (value) {
      return _then(_self.copyWith(applicant: value));
    });
  }
}

// dart format on
