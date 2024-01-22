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

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        primarySwatch: Colors.deepOrange,

        // appBarTheme: AppBarTheme(
        //     backgroundColor: Colors.white, foregroundColor: Colors.black),
      ),
      darkTheme: ThemeData(
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.deepOrange),
        brightness: Brightness.dark,
        checkboxTheme: CheckboxThemeData(
          checkColor:
              MaterialStateProperty.resolveWith((states) => Colors.black),
          fillColor: MaterialStateProperty.resolveWith(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors
                    .deepOrange; // Set your desired color for the selected checkbox in dark mode
              }
              return Colors
                  .transparent; // Set your desired color for the unselected checkbox in dark mode
            },
          ),
        ),

        primarySwatch: Colors.deepOrange,

        scaffoldBackgroundColor: Colors.grey.shade900,
        // appBarTheme: AppBarTheme(
        //     backgroundColor: Colors.black, foregroundColor: Colors.white),
      ),
      themeMode: themeMode,
      home: HomeScreen(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   static final ValueNotifier<ThemeMode> themeNotifier =
//       ValueNotifier(ThemeMode.light);
//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     return ValueListenableBuilder<ThemeMode>(
//         valueListenable: themeNotifier,
//         builder: (_, ThemeMode currentMode, __) {
//           return MaterialApp(
//             // Remove the debug banner
//             debugShowCheckedModeBanner: false,

//             theme: ThemeData(
//                 primarySwatch: Colors.cyan, brightness: Brightness.light),
//             darkTheme: ThemeData(
//                 primarySwatch: Colors.cyan, brightness: Brightness.dark),
//             themeMode: currentMode,
//             home: const HomeScreen(),
//           );
//         });
//   }
// }
