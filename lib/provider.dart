import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/mySharedPrefrences.dart';

final themeProvider = StateProvider<ThemeData>((ref) {
  // Default theme
  return ThemeData.light();
});
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  // Default theme mode
  return ThemeMode.light;
});
