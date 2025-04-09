// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../models/page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Page<T> _$PageFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Page<T>(
      (json['content'] as List<dynamic>).map(fromJsonT).toList(),
      (json['totalPages'] as num).toInt(),
      (json['totalElements'] as num).toInt(),
    );

Map<String, dynamic> _$PageToJson<T>(
  Page<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'content': instance.content.map(toJsonT).toList(),
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
    };
