// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

// 特別なJsonコンバータを追加する
class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime object) {
    return object.toIso8601String();
  }
}

@freezed
class Todo with _$Todo {
  const Todo._(); // プライベートコンストラクター（methodの追加に必要）
  const factory Todo({
    required int id,
    required String title,
    required String detail,
    @JsonKey(name: 'is_done') required bool isDone,
    @JsonKey(name: 'is_deleted') required bool isDeleted,
    @DateTimeConverter() required DateTime deadLine,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
