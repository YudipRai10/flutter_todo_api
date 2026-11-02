import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_api/models/todo.dart';

class TodoApi {
  static const String _baseUrl = 'https://dummyjson.com/todos';

  static Future<List<Todo>> fetchTodos() async {
    final uri = Uri.parse(_baseUrl);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final results = json['todos'] as List<dynamic>;
      return results.map((item) => Todo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load todos (status: ${response.statusCode})');
    }
  }

  static Future<Todo> addTodo({
    required String todo,
    bool completed = false,
    int userId = 5,
  }) async {
    final uri = Uri.parse('$_baseUrl/add');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'todo': todo,
        'completed': completed,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Todo.fromJson(json);
    } else {
      throw Exception('Failed to add todo (status: ${response.statusCode})');
    }
  }

  static Future<Todo> updateTodo({
    required int id,
    String? todo,
    bool? completed,
  }) async {
    final uri = Uri.parse('$_baseUrl/$id');
    final Map<String, dynamic> body = {};
    if (todo != null) body['todo'] = todo;
    if (completed != null) body['completed'] = completed;

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Todo.fromJson(json);
    } else {
      throw Exception('Failed to update todo (status: ${response.statusCode})');
    }
  }

  static Future<bool> deleteTodo(int id) async {
    final uri = Uri.parse('$_baseUrl/$id');
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete todo (status: ${response.statusCode})');
    }
  }
}
