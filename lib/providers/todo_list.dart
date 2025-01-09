import 'package:aws_todo_mobile/services/todo.dart';
import 'package:aws_todo_mobile/utils/logging.dart';
// 関数の自動生成を行う場合は必要
// ignore: unnecessary_import
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/todo.dart';

part 'todo_list.g.dart';

@riverpod
class TodoList extends _$TodoList {
  @override
  Future<List<Todo?>> build() async {
    // 初回目以降の再取得の際にも明示的にloadding状態を作りたい
    // (これを実行しないとstateが新しい状態に置き換わるだけでloadding状態が発生しない)
    // state = const AsyncValue.loading();

    // providerの削除時に実行(refはどこからでも取得可能)
    ref.onDispose(() {
      logger.info("todoListProvider is disposed");
    });
    return await TodoService().getAll();
  }

  // 以下参考までに
  // 自身を invalidate する
  // Future<void> refresh(Ref ref) async {
  //   ref.invalidate(todoListProvider); // 自分自身を無効化して再計算
  // }
}

// // NotifierないのでこっちでOK
// @riverpod
// Future<List<Todo>> todoList(Ref ref) async {
//   return await TodoService().getAll();
// }
