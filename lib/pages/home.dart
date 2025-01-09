import 'package:aws_todo_mobile/models/todo.dart';
import 'package:aws_todo_mobile/providers/todo_list.dart';
import 'package:aws_todo_mobile/services/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final todoService = TodoService();
  Future<void> _refreshData() async {
    ref.invalidate(todoListProvider);
  }

  Future<void> _addTodo() async {
    Navigator.of(context).pushNamed('/add');
    // todoService.add(
    //   "新しいTodo",
    //   "その詳細",
    //   DateTime(2024, 2, 22),
    // );
    // ref.invalidate(todoListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final todoList = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo一覧'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Changed to start for better layout
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: todoList.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return const Center(child: Text("No Data"));
                    }
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Todo? todo = data[index];
                        if (todo == null) return const SizedBox.shrink();
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/detail', arguments: todo);
                          },
                          child: TodoItem(
                            todo: todo,
                            todoService: todoService,
                            ref: ref,
                            todoList: data,
                            index: index,
                          ),
                        );
                      },
                    );
                  },
                  error: (err, _) {
                    return Center(
                      child: Text("$err"),
                    );
                  },
                  loading: () => Skeletonizer(
                    enabled: true,
                    child: ListView.builder(
                      itemCount: 10, // ローディング時のスケルトンアイテム数
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Container(
                            height: 20,
                            color: Colors.grey.shade300,
                          ),
                          trailing: Container(
                            width: 20,
                            height: 20,
                            color: Colors.grey.shade300,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: "todoを追加",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.todo,
    required this.todoService,
    required this.ref,
    required this.todoList,
    required this.index,
  });

  final Todo todo;
  final List<Todo?> todoList;
  final TodoService todoService;
  final WidgetRef ref;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id.toString()),
      direction: DismissDirection.endToStart, // スワイプ方向（右から左）
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) async {
        // Todoを削除(optimistic update)
        todoList.removeAt(index);
        await todoService.delete(todo.id);
        ref.invalidate(todoListProvider);

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todoを削除しました'),
          ),
        );
      },
      child: ListTile(
        title: Text(todo.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () async {
                await todoService.toggleIsDone(todo);
                ref.invalidate(todoListProvider);
              },
              icon: todo.isDone
                  ? const Icon(Icons.check_box_outlined)
                  : const Icon(Icons.check_box_outline_blank),
            ),
          ],
        ),
      ),
    );
  }
}
