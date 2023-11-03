import 'todo_fields.dart';
class ToDo {
  final int? id;
  final String title;
  bool isDone;

  ToDo({
    this.id,
    required this.title,
    this.isDone = false,
  });

  ToDo copy({
    int? id,
    String? title,
    bool? isDone,
  }) =>
      ToDo(
        id: id ?? this.id,
        title: title ?? this.title,
        isDone: isDone ?? this.isDone,
      );

  Map<String, Object?> toJson() => {
    ToDoFields.id: id,
    ToDoFields.title: title,
    ToDoFields.isDone: isDone ? 1 : 0,
  };

  static ToDo fromJson(Map<String, Object?> json) => ToDo(
    id: json[ToDoFields.id] as int?,
    title: json[ToDoFields.title] as String,
    isDone: json[ToDoFields.isDone] == 1,
  );
}
