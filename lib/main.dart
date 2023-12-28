import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:to_do_app/mySharedPrefrences.dart';
import 'package:to_do_app/provider.dart';

import 'homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPrefrences.init();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
  @override
  Widget build(
    BuildContext context,
  ) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            // Remove the debug banner
            debugShowCheckedModeBanner: false,

            theme: ThemeData(
                primarySwatch: Colors.cyan, brightness: Brightness.light),
            darkTheme: ThemeData(
                primarySwatch: Colors.cyan, brightness: Brightness.dark),
            themeMode: currentMode,
            home: const HomeScreen(),
          );
        });
  }
}
