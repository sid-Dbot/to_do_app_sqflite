import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/DB/dBrepo.dart';
import 'package:to_do_app/Models/toDo.dart';
import 'package:to_do_app/mySharedPrefrences.dart';

final themeProvider = StateProvider<ThemeData>((ref) {
  // Default theme
  return ThemeData.light();
});
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  // Default theme mode
  return ThemeMode.light;
});

final SelectedDayProvider = StateProvider<int>((ref) {
  return 0;
});

final todoProvider = StateNotifierProvider<TodoProvider, List<ToDoModel>>(
    (ref) => TodoProvider());

class TodoProvider extends StateNotifier<List<ToDoModel>> {
  TodoProvider() : super([]);
  List<ToDoModel> todos = [];

  void getTodos() async {
    await DbService().getAllTodos().then((value) => state = value);
  }
}
