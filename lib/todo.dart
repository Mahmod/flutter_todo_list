class ToDo {
  String id;
  String title;
  bool isDone;

  ToDo({required this.id, required this.title, this.isDone = false});

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isDone': isDone,
  };

  static ToDo fromJson(Map<String, dynamic> json) => ToDo(
    id: json['id'],
    title: json['title'],
    isDone: json['isDone'],
  );
}
