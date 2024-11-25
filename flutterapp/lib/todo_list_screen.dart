import 'package:flutter/material.dart';
import 'todo_service.dart';
import 'todo.dart';

class TodoListScreen extends StatefulWidget {
  final String userIdentifier;

  const TodoListScreen({super.key, required this.userIdentifier});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoService _todoService = TodoService();
  late String userIdentifier;
  List<Todo> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    userIdentifier = widget.userIdentifier; // Assign the identifier
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final todos = await _todoService.fetchTodos(userIdentifier);
      setState(() {
        _todos = todos;
      });
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addTodo() async {
    final titleController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),

            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text;

                if (title.isEmpty) return;

                final newTodo = Todo(
                  id: 0,
                  userIdentifier: userIdentifier,
                  title: title,
                  isCompleted: false,
                );

                try {
                  final createdTodo = await _todoService.createTodo(newTodo);
                  setState(() {
                    _todos.add(createdTodo);
                  });
                  Navigator.pop(context);
                } catch (e) {
                  _showError(e.toString());
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _toggleComplete(Todo todo) async {
    try {
      final updatedTodo = Todo(
        id: todo.id,
        userIdentifier: todo.userIdentifier,
        title: todo.title,
        isCompleted: !todo.isCompleted,
      );
      await _todoService.updateTodo(updatedTodo);
      setState(() {
        final index = _todos.indexWhere((t) => t.id == todo.id);
        _todos[index] = updatedTodo;
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _deleteTodo(Todo todo) async {
    try {
      await _todoService.deleteTodo(todo.id);
      setState(() {
        _todos.removeWhere((t) => t.id == todo.id);
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        centerTitle: true,
        title: const Text("T O D O  L I S T"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
                  itemCount: _todos.length,
                  itemBuilder: (context, index) {
          final todo = _todos[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        todo.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                      ),
                      onPressed: () => _toggleComplete(todo),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteTodo(todo),
                    ),
                  ],
                ),
              ),
            ),
          );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black54,
        onPressed: _addTodo,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
