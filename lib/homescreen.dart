import 'dart:math';

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

// int _selected = 0;

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DBService dbService = DBService();

  @override
  void initState() {
    // getTodos();
    ref.read(todoProvider.notifier).getTodos();

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
    DatabaseRepository().delete(todo.id).then((value) {
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
                  DayList(),
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
                        itemCount: 2,
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 2,
                            endIndent: MediaQuery.of(context).size.width - 175,
                          );
                        },
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                height: 50,
                                // padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                        shape: CircleBorder(),
                                        onChanged: (value) {
                                          _done = value!;

                                          setState(() {});
                                        },
                                        value: _done),
                                    Flexible(
                                      flex: 6,
                                      child: Text(
                                        myTodos[index].describtion,
                                        style: const TextStyle(
                                            // color: Colors.black,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.delete_outline,
                                            color: Colors.red.shade600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 15,
                                child: Divider(
                                  color: Colors.black,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      // Expanded(
                      //   child: ListView.separated(
                      //     separatorBuilder: (context, index) =>
                      //         const SizedBox(
                      //       height: 20,
                      //     ),
                      //     padding: const EdgeInsets.all(16),
                      //     itemBuilder: (context, index) {
                      //       final todo = myTodos[index];
                      //       return TodoWidget(
                      //         todo: ref
                      //             .watch(todoProvider.notifier)
                      //             .state[index],
                      //       );
                      //     },
                      //     itemCount:
                      //         ref.watch(todoProvider.notifier).state.length,
                      //   ),
                      // ),

                      // ElevatedButton(
                      //     onPressed: () {
                      //       showModalBottomSheet(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.only(
                      //                 topLeft: Radius.circular(16),
                      //                 topRight: Radius.circular(16))),
                      //         context: context,
                      //         builder: (context) {
                      //           return Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 ElevatedButton(
                      //                     onPressed: () {
                      //                       MySharedPrefrences.setTheme(false);
                      //                       // MyApp.themeNotifier.value =
                      //                       //     ThemeMode.dark;

                      //                       // context.read(themeProvider.notifier).toggleTheme();

                      //                       Navigator.pop(context);
                      //                     },
                      //                     child: Text('Dark')),
                      //                 ElevatedButton(
                      //                     onPressed: () {
                      //                       MySharedPrefrences.setTheme(true);
                      //                       // MyApp.themeNotifier.value =
                      //                       //     ThemeMode.light;
                      //                       // context.read(themeProvider.notifier).toggleTheme();
                      //                       Navigator.pop(context);
                      //                     },
                      //                     child: Text('Light'))
                      //               ],
                      //             ),
                      //           );
                      //         },
                      //       );
                      //     },
                      //     child: Text('Select Theme'))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class DayList extends ConsumerWidget {
  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int _selected = ref.watch(SelectedDayProvider);
    return Container(
      padding: EdgeInsets.all(4),
      width: double.infinity,
      height: 100,
      child: TweenAnimationBuilder(
          duration: Duration(seconds: 1),
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
                  future: Future.delayed(Duration(milliseconds: index * 100)),
                  builder: (context, snapsht) {
                    return Container(
                      height: 75,
                      width: 75,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                _selected == index ? Colors.white : Colors.grey,
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
                                    fontSize: 16, fontStyle: FontStyle.italic),
                              ),
                              Text(
                                DateFormat.d().format(
                                    DateTime.now().add(Duration(days: index))),
                                style: TextStyle(
                                    fontSize: 24,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    );
                  });
            },
          ),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, tween, child) {
            return Transform.translate(
              offset: Offset(0, 20 * sin(2 * pi * tween)),
              child: child,
            );
          }),
    );
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
                    ref.read(themeProvider.notifier).state = ThemeData.dark();
                    ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
                    // MyApp.themeNotifier.value = ThemeMode.dark;
                  } else {
                    MySharedPrefrences.setTheme(true);
                    ref.read(themeProvider.notifier).state = ThemeData.light();
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
