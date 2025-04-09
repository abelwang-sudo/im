import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/user_model.freezed.dart';
part '../generated/models/user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String username,
    String? nickname,
    String? avatar,
    required String email,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}