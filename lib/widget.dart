import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/addto.dart';

import 'package:to_do_app/toDo.dart';

class TodoWidget extends StatelessWidget {
  final ToDo todo;
  final VoidCallback onDeletePressed;

  const TodoWidget({
    Key? key,
    required this.todo,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final string = DateFormat("yyyy-MM-dd HH:mm:ss").parse(todo.createdAt);

    return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddTodo(
              todo: todo,
            );
          }));
        },
        child: Card(
          elevation: 8,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1)),
            child: ListTile(
              leading: Icon(Icons.bug_report_sharp),
              trailing: IconButton(
                onPressed: () {
                  onDeletePressed;
                },
                icon: Center(
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ),
              subtitle: Text(
                todo.title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              title: Text(
                DateFormat.yMMMd().format(string).toString(),
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ),
          ),
        ));
  }
}
