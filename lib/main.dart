import 'package:flutter/material.dart';
import 'package:to_do_app/mySharedPrefrences.dart';

import 'homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPrefrences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo app',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor:
                MySharedPrefrences.light ? Colors.white : Colors.black),
        home: HomeScreen());
  }
}
