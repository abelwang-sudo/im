// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../models/signature_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignatureModel {
  String get fileName;
  String get uploadUrl;
  String get fileUrl;

  /// Create a copy of SignatureModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SignatureModelCopyWith<SignatureModel> get copyWith =>
      _$SignatureModelCopyWithImpl<SignatureModel>(
          this as SignatureModel, _$identity);

  /// Serializes this SignatureModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignatureModel &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.uploadUrl, uploadUrl) ||
                other.uploadUrl == uploadUrl) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fileName, uploadUrl, fileUrl);

  @override
  String toString() {
    return 'SignatureModel(fileName: $fileName, uploadUrl: $uploadUrl, fileUrl: $fileUrl)';
  }
}

/// @nodoc
abstract mixin class $SignatureModelCopyWith<$Res> {
  factory $SignatureModelCopyWith(
          SignatureModel value, $Res Function(SignatureModel) _then) =
      _$SignatureModelCopyWithImpl;
  @useResult
  $Res call({String fileName, String uploadUrl, String fileUrl});
}

/// @nodoc
class _$SignatureModelCopyWithImpl<$Res>
    implements $SignatureModelCopyWith<$Res> {
  _$SignatureModelCopyWithImpl(this._self, this._then);

  final SignatureModel _self;
  final $Res Function(SignatureModel) _then;

  /// Create a copy of SignatureModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? uploadUrl = null,
    Object? fileUrl = null,
  }) {
    return _then(_self.copyWith(
      fileName: null == fileName
          ? _self.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      uploadUrl: null == uploadUrl
          ? _self.uploadUrl
          : uploadUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: null == fileUrl
          ? _self.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SignatureModel implements SignatureModel {
  const _SignatureModel(
      {required this.fileName, required this.uploadUrl, required this.fileUrl});
  factory _SignatureModel.fromJson(Map<String, dynamic> json) =>
      _$SignatureModelFromJson(json);

  @override
  final String fileName;
  @override
  final String uploadUrl;
  @override
  final String fileUrl;

  /// Create a copy of SignatureModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SignatureModelCopyWith<_SignatureModel> get copyWith =>
      __$SignatureModelCopyWithImpl<_SignatureModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SignatureModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SignatureModel &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.uploadUrl, uploadUrl) ||
                other.uploadUrl == uploadUrl) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fileName, uploadUrl, fileUrl);

  @override
  String toString() {
    return 'SignatureModel(fileName: $fileName, uploadUrl: $uploadUrl, fileUrl: $fileUrl)';
  }
}

/// @nodoc
abstract mixin class _$SignatureModelCopyWith<$Res>
    implements $SignatureModelCopyWith<$Res> {
  factory _$SignatureModelCopyWith(
          _SignatureModel value, $Res Function(_SignatureModel) _then) =
      __$SignatureModelCopyWithImpl;
  @override
  @useResult
  $Res call({String fileName, String uploadUrl, String fileUrl});
}

/// @nodoc
class __$SignatureModelCopyWithImpl<$Res>
    implements _$SignatureModelCopyWith<$Res> {
  __$SignatureModelCopyWithImpl(this._self, this._then);

  final _SignatureModel _self;
  final $Res Function(_SignatureModel) _then;

  /// Create a copy of SignatureModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? fileName = null,
    Object? uploadUrl = null,
    Object? fileUrl = null,
  }) {
    return _then(_SignatureModel(
      fileName: null == fileName
          ? _self.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      uploadUrl: null == uploadUrl
          ? _self.uploadUrl
          : uploadUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: null == fileUrl
          ? _self.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
