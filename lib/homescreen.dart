import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/DB/db_service.dart';
import 'package:to_do_app/addto.dart';
import 'package:to_do_app/dBrepo.dart';
import 'package:http/http.dart' as http;

import 'package:to_do_app/Models/toDo.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/mySharedPrefrences.dart';
import 'package:to_do_app/provider.dart';
import 'package:to_do_app/widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DBService dbService = DBService();

  @override
  void initState() {
    getTodos();
    ref.read(todoProvider.notifier).getTodos();

    super.initState();
  }

  List<ToDoModel> myTodos = [];

  void getTodos() async {
    await DatabaseRepository().getAllTodos().then((value) {
      setState(() {
        myTodos = value;
      });
    });
  }

  _getData() async {
    var response = await http
        .get(Uri.parse('http://localhost:5000/weatherforecast'), headers: {});
    print(response);
  }

  void delete({required ToDoModel todo, required BuildContext context}) async {
    DatabaseRepository().delete(todo.id).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    getTodos();

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor:
              MySharedPrefrences.light ? Colors.white : Colors.grey,
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            _getData();
            showDialog(
              context: context,
              builder: (context) => AddTodo(),
            );
          },
        ),
        appBar: AppBar(
          title: Center(child: const Text('My todos')),
          actions: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Consumer(builder: (context, ref, child) {
                return GestureDetector(
                  onTap: () {
                    if (MySharedPrefrences.light) {
                      MySharedPrefrences.setTheme(false);
                      // ref.read(themeProvider.notifier).state = ThemeData.dark();
                      ref.read(themeModeProvider.notifier).state =
                          ThemeMode.dark;
                      // MyApp.themeNotifier.value = ThemeMode.dark;
                    } else {
                      MySharedPrefrences.setTheme(true);
                      // ref.read(themeProvider.notifier).state =
                      //     ThemeData.light();
                      ref.read(themeModeProvider.notifier).state =
                          ThemeMode.light;
                      // MyApp.themeNotifier.value = ThemeMode.light;
                    }
                  },
                  child: Icon(
                    MySharedPrefrences.light
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                );
              }),
            )
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              getTodos();
              _getData();
              setState(() {});
            },
            child: myTodos.isEmpty
                ? const Center(child: Text('You don\'t have any todos yet'))
                : Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 20,
                          ),
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            final todo = myTodos[index];
                            return TodoWidget(
                              todo:
                                  ref.watch(todoProvider.notifier).state[index],
                            );
                          },
                          itemCount:
                              ref.watch(todoProvider.notifier).state.length,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16))),
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            MySharedPrefrences.setTheme(false);
                                            // MyApp.themeNotifier.value =
                                            //     ThemeMode.dark;

                                            // context.read(themeProvider.notifier).toggleTheme();

                                            Navigator.pop(context);
                                          },
                                          child: Text('Dark')),
                                      ElevatedButton(
                                          onPressed: () {
                                            MySharedPrefrences.setTheme(true);
                                            // MyApp.themeNotifier.value =
                                            //     ThemeMode.light;
                                            // context.read(themeProvider.notifier).toggleTheme();
                                            Navigator.pop(context);
                                          },
                                          child: Text('Light'))
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Text('Select Theme'))
                    ],
                  ),
          ),
        ));
  }
}
