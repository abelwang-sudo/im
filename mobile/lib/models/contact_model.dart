import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/contact_model.freezed.dart';
part '../generated/models/contact_model.g.dart';

enum UserStatus {
    @JsonValue('ONLINE')
    online,
    @JsonValue('OFFLINE')
    offline
}
@freezed
abstract class ContactModel with _$ContactModel {
  const factory ContactModel({
    /// id
    required int id,

    /// username
    required String username,

    /// email
    required String email,

    /// nickname
    String? nickname,

    /// avatar
    String? avatar,

    /// createdAt
    required num createdAt,

    /// updatedAt
    required num updatedAt,

    UserStatus? status,
  }) = _ContactModel;

  /// Deserializer...
  factory ContactModel.fromJson(Map<String, dynamic> json) => _$ContactModelFromJson(json);
}