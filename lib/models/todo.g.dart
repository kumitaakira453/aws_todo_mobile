// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoImpl _$$TodoImplFromJson(Map<String, dynamic> json) => _$TodoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      detail: json['detail'] as String,
      isDone: json['is_done'] as bool,
      isDeleted: json['is_deleted'] as bool,
      deadLine: const DateTimeConverter().fromJson(json['deadLine'] as String),
    );

Map<String, dynamic> _$$TodoImplToJson(_$TodoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'detail': instance.detail,
      'is_done': instance.isDone,
      'is_deleted': instance.isDeleted,
      'deadLine': const DateTimeConverter().toJson(instance.deadLine),
    };
