import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/DB/db_service.dart';
import 'package:to_do_app/addto.dart';
import 'package:to_do_app/dBrepo.dart';
import 'package:http/http.dart' as http;

import 'package:to_do_app/Models/toDo.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/mySharedPrefrences.dart';
import 'package:to_do_app/provider.dart';
import 'package:to_do_app/widget.dart';

String getWeekdayString(int weekday) {
  switch (weekday) {
    case 1:
      return 'MON';
    case 2:
      return 'TUE';
    case 3:
      return 'WED';
    case 4:
      return 'THU';
    case 5:
      return 'FRI';
    case 6:
      return 'SAT';
    case 7:
      return 'SUN';
    default:
      return '';
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DBService dbService = DBService();
  int _selected = 0;

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
    print(response.body);
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

  bool isPressed = false;

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
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  height: 90,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: () {
                            _selected = index;
                            // setState(() {});
                          },
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: _selected == index
                                      ? Colors.white
                                      : Colors.grey,
                                  backgroundColor: _selected == index
                                      ? Colors.deepOrange
                                      : Colors.white),
                              onPressed: () {
                                // _selected == index
                                //     ? isPressed = true
                                //     : isPressed = false;
                                // setState(() {});
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    getWeekdayString(DateTime.now()
                                        .add(Duration(days: index))
                                        .weekday),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                    DateFormat.d().format(DateTime.now()
                                        .add(Duration(days: index))),
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                  ),
                ),
                myTodos.isEmpty
                    ? Center(
                        child: Column(
                        children: [
                          Text('You don\'t have any todos yet'),
                          ElevatedButton(
                              onPressed: () {
                                _getData();
                              },
                              child: Text("Get Api")),
                        ],
                      ))
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 20,
                              ),
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (context, index) {
                                final todo = myTodos[index];
                                return TodoWidget(
                                  todo: ref
                                      .watch(todoProvider.notifier)
                                      .state[index],
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
                                                MySharedPrefrences.setTheme(
                                                    false);
                                                // MyApp.themeNotifier.value =
                                                //     ThemeMode.dark;

                                                // context.read(themeProvider.notifier).toggleTheme();

                                                Navigator.pop(context);
                                              },
                                              child: Text('Dark')),
                                          ElevatedButton(
                                              onPressed: () {
                                                MySharedPrefrences.setTheme(
                                                    true);
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
              ],
            ),
          ),
        ));
  }
}
