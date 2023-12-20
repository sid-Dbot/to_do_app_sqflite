import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/DB/db_service.dart';
import 'package:to_do_app/addto.dart';

import 'package:to_do_app/toDo.dart';

class TodoWidget extends StatelessWidget {
  final ToDo todo;

  TodoWidget({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final DBService dbService = DBService();

  _delete(int id) async {
    await dbService.delete(id);
  }

  @override
  Widget build(BuildContext context) {
    final string = DateFormat("yyyy-MM-dd HH:mm:ss").parse(todo.createdAt);

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
              color: Colors.grey.withOpacity(0.1)),
          child: Row(
            children: [
              Checkbox(
                  onChanged: (value) {
                    value = value!;
                  },
                  value: false),
              Column(
                children: [
                  Text(
                    DateFormat.yMMMd().format(string).toString(),
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  Text(
                    todo.title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      _delete(todo.id);
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
