// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../models/post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaModel {
  String get mediaUrl;
  String get mediaType;

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MediaModelCopyWith<MediaModel> get copyWith =>
      _$MediaModelCopyWithImpl<MediaModel>(this as MediaModel, _$identity);

  /// Serializes this MediaModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MediaModel &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mediaUrl, mediaType);

  @override
  String toString() {
    return 'MediaModel(mediaUrl: $mediaUrl, mediaType: $mediaType)';
  }
}

/// @nodoc
abstract mixin class $MediaModelCopyWith<$Res> {
  factory $MediaModelCopyWith(
          MediaModel value, $Res Function(MediaModel) _then) =
      _$MediaModelCopyWithImpl;
  @useResult
  $Res call({String mediaUrl, String mediaType});
}

/// @nodoc
class _$MediaModelCopyWithImpl<$Res> implements $MediaModelCopyWith<$Res> {
  _$MediaModelCopyWithImpl(this._self, this._then);

  final MediaModel _self;
  final $Res Function(MediaModel) _then;

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mediaUrl = null,
    Object? mediaType = null,
  }) {
    return _then(_self.copyWith(
      mediaUrl: null == mediaUrl
          ? _self.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _self.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _MediaModel implements MediaModel {
  const _MediaModel({required this.mediaUrl, required this.mediaType});
  factory _MediaModel.fromJson(Map<String, dynamic> json) =>
      _$MediaModelFromJson(json);

  @override
  final String mediaUrl;
  @override
  final String mediaType;

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MediaModelCopyWith<_MediaModel> get copyWith =>
      __$MediaModelCopyWithImpl<_MediaModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MediaModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MediaModel &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mediaUrl, mediaType);

  @override
  String toString() {
    return 'MediaModel(mediaUrl: $mediaUrl, mediaType: $mediaType)';
  }
}

/// @nodoc
abstract mixin class _$MediaModelCopyWith<$Res>
    implements $MediaModelCopyWith<$Res> {
  factory _$MediaModelCopyWith(
          _MediaModel value, $Res Function(_MediaModel) _then) =
      __$MediaModelCopyWithImpl;
  @override
  @useResult
  $Res call({String mediaUrl, String mediaType});
}

/// @nodoc
class __$MediaModelCopyWithImpl<$Res> implements _$MediaModelCopyWith<$Res> {
  __$MediaModelCopyWithImpl(this._self, this._then);

  final _MediaModel _self;
  final $Res Function(_MediaModel) _then;

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mediaUrl = null,
    Object? mediaType = null,
  }) {
    return _then(_MediaModel(
      mediaUrl: null == mediaUrl
          ? _self.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _self.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$PostModel {
  int get id;
  int get userId;
  String? get username;
  String? get nickname;
  String? get avatar;
  String get content;
  List<MediaModel>? get medias;
  String? get mediaType;
  int get createdAt;
  int get likeCount;
  bool? get liked;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostModelCopyWith<PostModel> get copyWith =>
      _$PostModelCopyWithImpl<PostModel>(this as PostModel, _$identity);

  /// Serializes this PostModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PostModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other.medias, medias) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.liked, liked) || other.liked == liked));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      username,
      nickname,
      avatar,
      content,
      const DeepCollectionEquality().hash(medias),
      mediaType,
      createdAt,
      likeCount,
      liked);

  @override
  String toString() {
    return 'PostModel(id: $id, userId: $userId, username: $username, nickname: $nickname, avatar: $avatar, content: $content, medias: $medias, mediaType: $mediaType, createdAt: $createdAt, likeCount: $likeCount, liked: $liked)';
  }
}

/// @nodoc
abstract mixin class $PostModelCopyWith<$Res> {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) _then) =
      _$PostModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int userId,
      String? username,
      String? nickname,
      String? avatar,
      String content,
      List<MediaModel>? medias,
      String? mediaType,
      int createdAt,
      int likeCount,
      bool? liked});
}

/// @nodoc
class _$PostModelCopyWithImpl<$Res> implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._self, this._then);

  final PostModel _self;
  final $Res Function(PostModel) _then;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? username = freezed,
    Object? nickname = freezed,
    Object? avatar = freezed,
    Object? content = null,
    Object? medias = freezed,
    Object? mediaType = freezed,
    Object? createdAt = null,
    Object? likeCount = null,
    Object? liked = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      medias: freezed == medias
          ? _self.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<MediaModel>?,
      mediaType: freezed == mediaType
          ? _self.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _self.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      liked: freezed == liked
          ? _self.liked
          : liked // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PostModel implements PostModel {
  const _PostModel(
      {required this.id,
      required this.userId,
      this.username,
      this.nickname,
      this.avatar,
      required this.content,
      final List<MediaModel>? medias,
      this.mediaType,
      required this.createdAt,
      required this.likeCount,
      this.liked})
      : _medias = medias;
  factory _PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  @override
  final int id;
  @override
  final int userId;
  @override
  final String? username;
  @override
  final String? nickname;
  @override
  final String? avatar;
  @override
  final String content;
  final List<MediaModel>? _medias;
  @override
  List<MediaModel>? get medias {
    final value = _medias;
    if (value == null) return null;
    if (_medias is EqualUnmodifiableListView) return _medias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? mediaType;
  @override
  final int createdAt;
  @override
  final int likeCount;
  @override
  final bool? liked;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PostModelCopyWith<_PostModel> get copyWith =>
      __$PostModelCopyWithImpl<_PostModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PostModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PostModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.liked, liked) || other.liked == liked));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      username,
      nickname,
      avatar,
      content,
      const DeepCollectionEquality().hash(_medias),
      mediaType,
      createdAt,
      likeCount,
      liked);

  @override
  String toString() {
    return 'PostModel(id: $id, userId: $userId, username: $username, nickname: $nickname, avatar: $avatar, content: $content, medias: $medias, mediaType: $mediaType, createdAt: $createdAt, likeCount: $likeCount, liked: $liked)';
  }
}

/// @nodoc
abstract mixin class _$PostModelCopyWith<$Res>
    implements $PostModelCopyWith<$Res> {
  factory _$PostModelCopyWith(
          _PostModel value, $Res Function(_PostModel) _then) =
      __$PostModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int userId,
      String? username,
      String? nickname,
      String? avatar,
      String content,
      List<MediaModel>? medias,
      String? mediaType,
      int createdAt,
      int likeCount,
      bool? liked});
}

/// @nodoc
class __$PostModelCopyWithImpl<$Res> implements _$PostModelCopyWith<$Res> {
  __$PostModelCopyWithImpl(this._self, this._then);

  final _PostModel _self;
  final $Res Function(_PostModel) _then;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? username = freezed,
    Object? nickname = freezed,
    Object? avatar = freezed,
    Object? content = null,
    Object? medias = freezed,
    Object? mediaType = freezed,
    Object? createdAt = null,
    Object? likeCount = null,
    Object? liked = freezed,
  }) {
    return _then(_PostModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      medias: freezed == medias
          ? _self._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<MediaModel>?,
      mediaType: freezed == mediaType
          ? _self.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _self.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      liked: freezed == liked
          ? _self.liked
          : liked // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on
