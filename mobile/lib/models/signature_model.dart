import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/signature_model.freezed.dart';
part '../generated/models/signature_model.g.dart';

@freezed
abstract class SignatureModel with _$SignatureModel {
  const factory SignatureModel({
    required String fileName,
    required String uploadUrl,
    required String fileUrl,
  }) = _SignatureModel;

  factory SignatureModel.fromJson(Map<String, dynamic> json) =>
      _$SignatureModelFromJson(json);
}