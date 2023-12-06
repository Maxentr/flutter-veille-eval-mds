class Todo {
  int id;
  String title;
  bool completed;

  Todo({required this.id, required this.title, required this.completed});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'completed': completed ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      completed: map['completed'] == 1,
    );
  }
}
