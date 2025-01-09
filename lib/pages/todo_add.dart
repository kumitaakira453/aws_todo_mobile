import 'package:aws_todo_mobile/providers/todo_list.dart';
import 'package:aws_todo_mobile/services/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoAddPage extends ConsumerStatefulWidget {
  const TodoAddPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoAddPageState();
}

class _TodoAddPageState extends ConsumerState<TodoAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleKey = GlobalKey<FormFieldState>();
  final _detailKey = GlobalKey<FormFieldState>();
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo追加"),
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
                    bool isSuccess = await TodoService().add(
                      _titleKey.currentState!.value,
                      _detailKey.currentState!.value,
                      _selectedDate,
                    );
                    if (!context.mounted) return;
                    if (!isSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Todoの登録に失敗しました',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Todoを登録しました',
                        ),
                      ),
                    );
                    ref.invalidate(todoListProvider);
                    Navigator.of(context).pop();
                  },
                  child: const Text('追加'),
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
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
