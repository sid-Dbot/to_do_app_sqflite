import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/Models/toDo.dart';
import 'package:to_do_app/mySharedPrefrences.dart';

import 'DB/db_service.dart';

final themeProvider = StateProvider<ThemeData>((ref) {
  // Default theme
  return ThemeData.light();
});
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  // Default theme mode
  return ThemeMode.light;
});

final todoProvider = StateNotifierProvider<TodoProvider, List<ToDoModel>>(
    (ref) => TodoProvider());

class TodoProvider extends StateNotifier<List<ToDoModel>> {
  TodoProvider() : super([]);
  List<ToDoModel> todos = [];

  void getTodos() async {
    await DBService().getAllTodos().then((value) => state = value);
  }
}
