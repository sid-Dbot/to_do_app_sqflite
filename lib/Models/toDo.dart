class ToDoModel {
  final int id;
  final bool isDone;
  final String title;
  final String describtion;
  ToDoModel(
      {required this.title,
      required this.id,
      required this.describtion,
      required this.isDone});
  factory ToDoModel.fromJson(Map<String, dynamic> map) {
    return ToDoModel(
      title: map['title'],
      id: map['id'],
      describtion: map['describtion'],
      isDone: map['isDone'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'describtion': describtion,
      'isDone': isDone,
    };
  }
}

class ToDo {
  final int id;
  final String title;
  final String createdAt;
  ToDo({required this.id, required this.title, required this.createdAt});
  factory ToDo.fromJson(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      title: map['title'],
      createdAt: map['createdAt'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'createdAt': createdAt,
    };
  }
}
