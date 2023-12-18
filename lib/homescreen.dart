import 'package:flutter/material.dart';
import 'package:to_do_app/DB/db_service.dart';
import 'package:to_do_app/addto.dart';
import 'package:to_do_app/dBrepo.dart';
import 'package:to_do_app/dog.dart';
import 'package:to_do_app/toDo.dart';
import 'package:to_do_app/widget.dart';
import 'dogRepo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBService dbService = DBService();
  @override
  void initState() {
    getTodos();

    super.initState();
  }

  List<ToDo> myTodos = [];

  void getTodos() async {
    await dbService.getAllTodos().then((value) {
      setState(() {
        myTodos = value;
      });
    }).catchError((e) => debugPrint(e.toString()));
  }

  void delete({required ToDoModel todo, required BuildContext context}) async {
    DatabaseRepository.instance.delete(todo.id).then((value) {
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
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddTodo(),
            );
          },
        ),
        appBar: AppBar(
          title: const Text('My todos'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.menu),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            getTodos();
            setState(() {});
          },
          child: myTodos.isEmpty
              ? const Center(child: const Text('You don\'t have any todos yet'))
              : ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 20,
                  ),
                  padding: EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final todo = myTodos[index];
                    return TodoWidget(
                      todo: todo,
                    );
                  },
                  itemCount: myTodos.length,
                ),
        ));
  }
}
