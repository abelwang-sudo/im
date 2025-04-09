import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/page_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Page<T> {
  late List<T> content;
  late int totalPages;
  late int totalElements;

  Page(this.content, this.totalPages, this.totalElements);

  factory Page.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) =>
      _$PageFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PageToJson(this, toJsonT);
}