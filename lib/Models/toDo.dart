class ToDoModel {
  final int id;
  final bool isDone;
  final String taskFor;
  final String describtion;
  ToDoModel(
      {required this.taskFor,
      required this.id,
      required this.describtion,
      required this.isDone});
  factory ToDoModel.fromJson(Map<String, dynamic> map) {
    return ToDoModel(
      taskFor: map['taskFor'],
      id: map['id'],
      describtion: map['describtion'],
      isDone: map['isDone'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'taskFor': taskFor,
      'id': id,
      'describtion': describtion,
      'isDone': isDone,
    };
  }
}

class ToDo {
  final int id;
  final String taskFor;
  final String createdAt;
  ToDo({required this.id, required this.taskFor, required this.createdAt});
  factory ToDo.fromJson(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      taskFor: map['taskFor'],
      createdAt: map['createdAt'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'taskFor': taskFor,
      'id': id,
      'createdAt': createdAt,
    };
  }
}
