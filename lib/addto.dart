import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/Models/toDo.dart';

import 'DB/dBrepo.dart';
import 'getWeekDayMethod.dart';
import 'provider.dart';

class AddTodo extends StatefulWidget {
  ToDo? todo;
  AddTodo({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final titleController = TextEditingController();
  DbService dbService = DbService();

  @override
  void initState() {
    addTodoData();

    super.initState();
  }

  void addTodoData() {
    if (widget.todo != null) {
      if (mounted) {
        setState(() {
          titleController.text = widget.todo!.taskFor;
        });
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  void addTodo() async {
    // ToDo dog = ToDo(
    //     id: DateTime.now().microsecondsSinceEpoch,
    //     taskFor: titleController.text,
    //     createdAt: DateTime.now().toString());

    // await dbService.insert(todo: );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // titlePadding: EdgeInsets.all(4),
      contentPadding: EdgeInsets.all(8),
      actionsPadding: EdgeInsets.all(8),
      actions: [
        Center(
          child: ElevatedButton(
            // color: Colors.black,

            onPressed: () async {
              addTodo();
            },
            child: const Text(
              'Add todo',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
      // title: Text('Add Todo'),
      content: SizedBox.square(
        dimension: 170,
        child: Column(
          children: [
            TextFormField(
              maxLines: 4,
              onFieldSubmitted: (value) => addTodo(),
              controller: titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(gapPadding: 0),
                  // label: const Text('Todo title'),
                  hintText: 'Develop amazing app '),
            ),
            SizedBox(height: 10, child: DayList()),
          ],
        ),
      ),
    );
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
        height: 10,
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
