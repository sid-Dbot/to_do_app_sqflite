import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:to_do_app/addto.dart';
import 'package:to_do_app/DB/dBrepo.dart';
import 'package:http/http.dart' as http;

import 'package:to_do_app/Models/toDo.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/mySharedPrefrences.dart';
import 'package:to_do_app/provider.dart';
import 'package:to_do_app/widget.dart';

import 'getWeekDayMethod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

// int _selected = 0;

class _HomeScreenState extends ConsumerState<HomeScreen> {
  _getTheme() {
    if (MySharedPrefrences.light) {
      // ref.read(themeProvider.notifier).state = ThemeData.dark();
      ref.read(themeModeProvider.notifier).state = ThemeMode.light;
      // MyApp.themeNotifier.value = ThemeMode.dark;
    } else {
      // ref.read(themeProvider.notifier).state = ThemeData.light();
      ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
      // MyApp.themeNotifier.value = ThemeMode.light;
    }
  }

  @override
  void initState() {
    // getTodos();
    ref.read(todoProvider.notifier).getTodos();
    Future.delayed(Duration.zero).then(
      (value) => _getTheme(),
    );

    super.initState();
  }

  List<ToDoModel> myTodos = [
    ToDoModel(
        id: 1,
        describtion: 'THis is the first task to be done.',
        isDone: false,
        taskFor: '3/1/2024'),
    ToDoModel(
        id: 1,
        describtion: 'THis is the first task to be done.',
        isDone: false,
        taskFor: '3/1/2024')
  ];

  // void getTodos() async {
  //   await DatabaseRepository().getAllTodos().then((value) {
  //     setState(() {
  //       myTodos = value;
  //     });
  //   });
  // }

  _getData() async {
    var response = await http
        .get(Uri.parse('http://10.0.2.2:5000/weatherforecast'), headers: {});
    print(response.body);
  }

  void delete({required ToDoModel todo, required BuildContext context}) async {
    DbService().delete(todo.id).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }

  bool isPressed = false;
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    // getTodos();

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            // _getData();
            showDialog(
              context: context,
              builder: (context) => AddTodo(),
            );
          },
        ),
        // appBar: AppBar(
        //   title: const Text('Your Tasks'),
        //   actions: [
        //     Padding(
        //       padding: EdgeInsets.all(12.0),
        //       child: Consumer(builder: (context, ref, child) {
        //         return GestureDetector(
        //           onTap: () {
        //             if (MySharedPrefrences.light) {
        //               MySharedPrefrences.setTheme(false);
        //               // ref.read(themeProvider.notifier).state = ThemeData.dark();
        //               ref.read(themeModeProvider.notifier).state =
        //                   ThemeMode.dark;
        //               // MyApp.themeNotifier.value = ThemeMode.dark;
        //             } else {
        //               MySharedPrefrences.setTheme(true);
        //               // ref.read(themeProvider.notifier).state =
        //               //     ThemeData.light();
        //               ref.read(themeModeProvider.notifier).state =
        //                   ThemeMode.light;
        //               // MyApp.themeNotifier.value = ThemeMode.light;
        //             }
        //           },
        //           child: Icon(
        //             MySharedPrefrences.light
        //                 ? Icons.light_mode
        //                 : Icons.dark_mode,
        //           ),
        //         );
        //       }),
        //     )
        //   ],
        // ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              // getTodos();
              _getData();
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  SizedBox(height: 50, child: Center(child: ScreenTitle())),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    child: DayList(),
                    height: 80,
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  // myTodos.isEmpty
                  //     ? Center(
                  //         child: Column(
                  //         children: [
                  //           Text('You don\'t have any todos yet'),
                  //           ElevatedButton(
                  //               onPressed: () {
                  //                 _getData();
                  //               },
                  //               child: Text("Get Api")),
                  //         ],
                  //       ))
                  //     :

                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    width: 200,
                                    height: 100,
                                    child: Center(child: Text('text')),
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 35,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(
                                      shape: CircleBorder(),
                                      onChanged: (value) {
                                        _done = value!;

                                        setState(() {});
                                      },
                                      value: _done),
                                  Expanded(
                                    // flex: 0,
                                    child: Text(
                                      myTodos[index].describtion,
                                      style: const TextStyle(
                                          // color: Colors.black,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  // IconButton(
                                  //   onPressed: () {},
                                  //   icon: Icon(
                                  //     Icons.delete_outline,
                                  //     color: Colors.red.shade600,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class DayList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      int _selected = ref.watch(SelectedDayProvider);
      return Container(
        padding: EdgeInsets.all(4),
        width: double.infinity,
        height: 70,
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 10,
            );
          },
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (context, index) {
            return FutureBuilder(
                future: Future.delayed(
                    Duration(milliseconds: index * 200), () => true),
                builder: (context, snapsht) {
                  return snapsht.connectionState == ConnectionState.done
                      ? TweenAnimationBuilder(
                          duration: Duration(milliseconds: 500),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: _selected == index
                                      ? Colors.white
                                      : Colors.grey,
                                  backgroundColor: _selected == index
                                      ? Colors.deepOrange
                                      : Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  ref.read(SelectedDayProvider.notifier).state =
                                      index;
                                  // _selected = index;
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
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, tween, child) {
                            return Transform.scale(
                              // offset: Offset(0, 20 * sin(2 * pi * tween)),
                              scale: tween,
                              child: child,
                            );
                          })
                      : Container();
                });
          },
        ),
      );
    });
  }
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        duration: Duration(milliseconds: 700),
        tween: Tween<double>(begin: 0, end: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Your Tasks',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
            ),
            Consumer(builder: (context, ref, child) {
              return GestureDetector(
                onTap: () {
                  if (MySharedPrefrences.light) {
                    MySharedPrefrences.setTheme(false);
                    // ref.read(themeProvider.notifier).state = ThemeData.dark();
                    ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
                    // MyApp.themeNotifier.value = ThemeMode.dark;
                  } else {
                    MySharedPrefrences.setTheme(true);
                    // ref.read(themeProvider.notifier).state = ThemeData.light();
                    ref.read(themeModeProvider.notifier).state =
                        ThemeMode.light;
                    // MyApp.themeNotifier.value = ThemeMode.light;
                  }
                },
                child: TweenAnimationBuilder(
                    child: Icon(
                      MySharedPrefrences.light
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                    duration: Duration(milliseconds: 700),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, tween, child) {
                      return Transform.scale(
                          // offset: Offset(0, 20 * sin(2 * pi * tween)),
                          scale: tween,
                          child: child);
                    }),
              );
            })
          ],
        ),
        builder: (context, tween, child) {
          return Opacity(
            opacity: tween,
            child: Padding(
              padding: EdgeInsets.only(top: tween * 20),
              child: child,
            ),
          );
        });
  }
}
