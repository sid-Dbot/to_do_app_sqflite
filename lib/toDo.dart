class ToDoModel {
  final int id;
  final bool isImportant;
  final String title;
  final String discribtion;
  ToDoModel(
      {required this.title,
      required this.id,
      required this.discribtion,
      required this.isImportant});
  factory ToDoModel.fromJson(Map<String, dynamic> map) {
    return ToDoModel(
      title: map['title'],
      id: map['id'],
      discribtion: map['discribtion'],
      isImportant: map['isImportant'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'discribtion': discribtion,
      'isImportant': isImportant,
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
