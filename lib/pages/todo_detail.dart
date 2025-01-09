import 'package:aws_todo_mobile/models/todo.dart';
import 'package:aws_todo_mobile/providers/todo_list.dart';
import 'package:aws_todo_mobile/services/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoDetailPage extends ConsumerStatefulWidget {
  const TodoDetailPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends ConsumerState<TodoDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleKey = GlobalKey<FormFieldState>();
  final _detailKey = GlobalKey<FormFieldState>();
  DateTime _selectedDate = DateTime.now();
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  late Todo todo;

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // buildの直前に一回だけ呼ばれる
    super.didChangeDependencies();

    todo = ModalRoute.of(context)?.settings.arguments as Todo;
    _titleController.text = todo.title;
    _detailController.text = todo.detail;
    _selectedDate = todo.deadLine;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo編集"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: _titleKey,
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "タイトル",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "タイトルを入力してください";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    key: _detailKey,
                    controller: _detailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "詳細",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "詳細を入力してください";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 6,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '期限',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: width * 0.7,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  ),
                  onPressed: () async {
                    _formKey.currentState!.validate();
                    bool isSuccess = await TodoService().edit(
                      todo.id,
                      _titleKey.currentState!.value,
                      _detailKey.currentState!.value,
                      _selectedDate,
                    );
                    if (!context.mounted) return;
                    if (!isSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Todoの変更に失敗しました',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Todoを変更しました',
                        ),
                      ),
                    );
                    ref.invalidate(todoListProvider);
                    Navigator.of(context).pop();
                  },
                  child: const Text('保存'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
