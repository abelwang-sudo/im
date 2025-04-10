// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/signature_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignatureModel _$SignatureModelFromJson(Map<String, dynamic> json) =>
    _SignatureModel(
      fileName: json['fileName'] as String,
      uploadUrl: json['uploadUrl'] as String,
      fileUrl: json['fileUrl'] as String,
    );

Map<String, dynamic> _$SignatureModelToJson(_SignatureModel instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'uploadUrl': instance.uploadUrl,
      'fileUrl': instance.fileUrl,
    };
