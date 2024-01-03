import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/DB/db_service.dart';
import 'package:to_do_app/addto.dart';

import 'package:to_do_app/Models/toDo.dart';
import 'package:to_do_app/mySharedPrefrences.dart';

class TodoWidget extends StatefulWidget {
  final ToDoModel todo;

  TodoWidget({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  final DBService dbService = DBService();
  bool _done = false;

  _delete(int id) async {
    await dbService.delete(id);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return AddTodo(
          //     todo: todo,
          //   );
          // }));
        },
        child: Container(
          height: 50,
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              color:
                  MySharedPrefrences.light ? Colors.black12 : Colors.black45),
          child: Row(
            children: [
              Checkbox(
                  onChanged: (value) {
                    _done = value!;

                    setState(() {});
                  },
                  value: _done),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "fsa",
                    style: const TextStyle(
                      // color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    ' widget.todo.title',
                    style: const TextStyle(
                        // color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      _delete(widget.todo.id);
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
