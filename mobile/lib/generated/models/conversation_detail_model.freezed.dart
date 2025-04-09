// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../models/conversation_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationDetailModel {
  int get id;
  String get type;
  String? get name;
  String? get avatar;
  int get createdAt;
  int get updatedAt;
  List<ConversationMemberModel> get members;

  /// Create a copy of ConversationDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConversationDetailModelCopyWith<ConversationDetailModel> get copyWith =>
      _$ConversationDetailModelCopyWithImpl<ConversationDetailModel>(
          this as ConversationDetailModel, _$identity);

  /// Serializes this ConversationDetailModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConversationDetailModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.members, members));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, name, avatar,
      createdAt, updatedAt, const DeepCollectionEquality().hash(members));

  @override
  String toString() {
    return 'ConversationDetailModel(id: $id, type: $type, name: $name, avatar: $avatar, createdAt: $createdAt, updatedAt: $updatedAt, members: $members)';
  }
}

/// @nodoc
abstract mixin class $ConversationDetailModelCopyWith<$Res> {
  factory $ConversationDetailModelCopyWith(ConversationDetailModel value,
          $Res Function(ConversationDetailModel) _then) =
      _$ConversationDetailModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String type,
      String? name,
      String? avatar,
      int createdAt,
      int updatedAt,
      List<ConversationMemberModel> members});
}

/// @nodoc
class _$ConversationDetailModelCopyWithImpl<$Res>
    implements $ConversationDetailModelCopyWith<$Res> {
  _$ConversationDetailModelCopyWithImpl(this._self, this._then);

  final ConversationDetailModel _self;
  final $Res Function(ConversationDetailModel) _then;

  /// Create a copy of ConversationDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = freezed,
    Object? avatar = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? members = null,
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
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      members: null == members
          ? _self.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ConversationMemberModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ConversationDetailModel implements ConversationDetailModel {
  const _ConversationDetailModel(
      {required this.id,
      required this.type,
      this.name,
      this.avatar,
      required this.createdAt,
      required this.updatedAt,
      required final List<ConversationMemberModel> members})
      : _members = members;
  factory _ConversationDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationDetailModelFromJson(json);

  @override
  final int id;
  @override
  final String type;
  @override
  final String? name;
  @override
  final String? avatar;
  @override
  final int createdAt;
  @override
  final int updatedAt;
  final List<ConversationMemberModel> _members;
  @override
  List<ConversationMemberModel> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  /// Create a copy of ConversationDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConversationDetailModelCopyWith<_ConversationDetailModel> get copyWith =>
      __$ConversationDetailModelCopyWithImpl<_ConversationDetailModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConversationDetailModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConversationDetailModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, name, avatar,
      createdAt, updatedAt, const DeepCollectionEquality().hash(_members));

  @override
  String toString() {
    return 'ConversationDetailModel(id: $id, type: $type, name: $name, avatar: $avatar, createdAt: $createdAt, updatedAt: $updatedAt, members: $members)';
  }
}

/// @nodoc
abstract mixin class _$ConversationDetailModelCopyWith<$Res>
    implements $ConversationDetailModelCopyWith<$Res> {
  factory _$ConversationDetailModelCopyWith(_ConversationDetailModel value,
          $Res Function(_ConversationDetailModel) _then) =
      __$ConversationDetailModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String type,
      String? name,
      String? avatar,
      int createdAt,
      int updatedAt,
      List<ConversationMemberModel> members});
}

/// @nodoc
class __$ConversationDetailModelCopyWithImpl<$Res>
    implements _$ConversationDetailModelCopyWith<$Res> {
  __$ConversationDetailModelCopyWithImpl(this._self, this._then);

  final _ConversationDetailModel _self;
  final $Res Function(_ConversationDetailModel) _then;

  /// Create a copy of ConversationDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = freezed,
    Object? avatar = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? members = null,
  }) {
    return _then(_ConversationDetailModel(
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
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      members: null == members
          ? _self._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ConversationMemberModel>,
    ));
  }
}

// dart format on
