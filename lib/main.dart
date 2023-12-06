import 'package:eval_veille/models/todo.dart';
import 'package:flutter/material.dart';
import 'package:eval_veille/database/todo_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  final TextEditingController _controller = TextEditingController();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  _loadTodos() async {
    _todos = await TodoService.instance.getAllTodos();
    setState(() {});
  }

  _addTodo() async {
    String title = _controller.text;
    if (title.isNotEmpty) {
      await TodoService.instance.insertTodo(
        Todo(
            id: DateTime.now().millisecondsSinceEpoch,
            title: title,
            completed: false),
      );
      _controller.clear();
      _loadTodos();
    }
  }

  _toggleTodoCompletion(Todo todo) async {
    todo.completed = !todo.completed;
    await TodoService.instance.updateTodoCompletion(todo);
    _loadTodos();
  }

  _deleteTodo(int id) async {
    await TodoService.instance.deleteTodo(id);
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Entrer une nouvelle tâche',
            ),
          ),
          ElevatedButton(
            onPressed: _addTodo,
            child: const Text('Ajouter'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_todos[index].title),
                  leading: Checkbox(
                    value: _todos[index].completed,
                    onChanged: (_) => _toggleTodoCompletion(_todos[index]),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTodo(_todos[index].id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
