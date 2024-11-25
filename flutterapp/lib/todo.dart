class Todo {
  final int id;
  final String userIdentifier;
  final String title;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.userIdentifier,
    required this.title,
    required this.isCompleted,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      userIdentifier: json['user_identifier'],
      title: json['title'],
      isCompleted: json['is_completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_identifier': userIdentifier,
      'title': title,
      'is_completed': isCompleted,
    };
  }
}
