import 'package:flutter/material.dart';

import 'package:to_do_app/DB/db_service.dart';

import 'package:to_do_app/Models/toDo.dart';

class AddTodo extends StatefulWidget {
  ToDo? todo;
  AddTodo({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final titleController = TextEditingController();
  DBService dbService = DBService();

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
    ToDo dog = ToDo(
        id: DateTime.now().microsecondsSinceEpoch,
        taskFor: titleController.text,
        createdAt: DateTime.now().toString());

    await dbService.insert(todo: dog);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // titlePadding: EdgeInsets.all(4),
      // contentPadding: EdgeInsets.all(8),
      actionsPadding: EdgeInsets.all(16),
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
      title: Text('Add Todo'),
      content: TextFormField(
        onFieldSubmitted: (value) => addTodo(),
        controller: titleController,
        decoration: const InputDecoration(
            label: const Text('Todo title'), hintText: 'Develop amazing app '),
      ),
    );
  }
}
