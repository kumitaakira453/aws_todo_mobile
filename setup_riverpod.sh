#!/bin/bash
# riverpod freezedのセットアップ
# Add regular dependencies
flutter pub add flutter_riverpod
flutter pub add freezed_annotation
flutter pub add json_annotation
flutter pub add riverpod_annotation

# Add dev_dependencies
flutter pub add --dev flutter_lints
flutter pub add --dev build_runner
flutter pub add --dev freezed
flutter pub add --dev json_serializable
flutter pub add --dev riverpod_generator

# build_runnerの実行
dart run build_runner watch
