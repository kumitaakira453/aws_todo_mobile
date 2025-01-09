import 'package:aws_todo_mobile/models/todo.dart';
import 'package:aws_todo_mobile/services/http.dart';
import 'package:aws_todo_mobile/services/urls.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class TodoService {
  final HttpService httpService = HttpService();
  TodoService();

  Future<List<Todo>> getAll() async {
    try {
      final response = await httpService.dio.request(
        Urls.getAllTodo,
        options: Options(method: 'GET'),
      );
      final List<dynamic> data = response.data["Items"] as List<dynamic>;
      return data
          .map((json) => Todo.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> delete(int id) async {
    try {
      await httpService.dio.request(
        Urls.manageTodo,
        options: Options(method: "POST"),
        data: {
          "post_type": "update_is_deleted",
          "id": id,
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> toggleIsDone(Todo todo) async {
    try {
      await httpService.dio.request(
        Urls.manageTodo,
        options: Options(method: "POST"),
        data: {
          "post_type": "update_is_done",
          "id": todo.id,
          "is_done": !todo.isDone,
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<bool> add(String title, String detail, DateTime deadLine) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(deadLine);
    try {
      await httpService.dio.request(
        Urls.manageTodo,
        options: Options(method: "POST"),
        data: {
          "post_type": "create_new",
          "title": title,
          "detail": detail,
          "deadLine": formattedDate
        },
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> edit(
    int id,
    String title,
    String detail,
    DateTime deadLine,
  ) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(deadLine);
    try {
      await httpService.dio.request(
        Urls.manageTodo,
        options: Options(method: "POST"),
        data: {
          "post_type": "update_content",
          "id": id,
          "title": title,
          "detail": detail,
          "deadLine": formattedDate
        },
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
