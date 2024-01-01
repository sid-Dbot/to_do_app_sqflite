import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/Models/toDo.dart';

class DBService {
  Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await init();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'todo.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> init() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) => db.execute(
          'CREATE TABLE IF NOT EXISTS todo(id INTEGER PRIMARY KEY,title TEXT,createdAt TEXT)'),
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion > 2) {
          db.execute(
              'CREATE TABLE todos(id INTEGER PRIMARY KEY auto_increment,title TEXT,description TEXT,isDone BOOL)');
          db.execute('DROP TABLE todo');
        }
      },
    );
    return database;
  }

  Future<List<ToDo>> getAllTodos() async {
    final db = await database;

    final result = await db.query('todo');

    return result.map((json) => ToDo.fromJson(json)).toList();
  }

  Future<void> insert({required ToDo todo}) async {
    try {
      final db = await database;
      db.insert('todo', todo.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> delete(int id) async {
    try {
      final db = await database;
      await db.delete(
        'todo',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> update(ToDoModel todo) async {
  //   try {
  //     final db = await database;
  //     db.update(
  //       'todo',
  //       todo.toMap(),
  //       where: '${id} = ?',
  //       whereArgs: [todo.id],
  //     );
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
