import 'dart:convert';
import 'package:http/http.dart' as http;
import 'todo.dart';

class TodoService {
  final String baseUrl = 'http://10.0.2.2:8000/api/todos/';

  Future<List<Todo>> fetchTodos(String userIdentifier) async {
    final response = await http.get(Uri.parse('$baseUrl?user_identifier=$userIdentifier'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<Todo> createTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()),
    );
    if (response.statusCode == 201) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create todo');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    await http.put(
      Uri.parse('$baseUrl${todo.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()),
    );
  }

  Future<void> deleteTodo(int id) async {
    await http.delete(Uri.parse('$baseUrl$id/'));
  }
}
