import 'package:eval_veille/models/todo.dart';
import 'package:sqflite/sqflite.dart';

import 'db.dart';

class TodoService {
  static final TodoService instance = TodoService._privateConstructor();

  TodoService._privateConstructor();

  Future<int> insertTodo(Todo todo) async {
    Database db = await DB.instance.database;
    return await db.insert('todos', todo.toMap());
  }

  Future<List<Todo>> getAllTodos() async {
    Database db = await DB.instance.database;
    List<Map<String, dynamic>> maps = await db.query('todos');
    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  Future<void> updateTodoCompletion(Todo todo) async {
    Database db = await DB.instance.database;
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> deleteTodo(int id) async {
    Database db = await DB.instance.database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
