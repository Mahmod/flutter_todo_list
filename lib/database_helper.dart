import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'todo.dart';
import 'todo_fields.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    // Creating the to-do table
    await db.execute('''
    CREATE TABLE $tableTodo ( 
      ${ToDoFields.id} $idType, 
      ${ToDoFields.title} $textType,
      ${ToDoFields.isDone} $boolType
    )
    ''');
  }

  Future<ToDo> create(ToDo todo) async {
    final db = await instance.database;
    final id = await db.insert(tableTodo, todo.toJson());
    return todo.copy(id: id);
  }

  Future<ToDo> readToDo(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableTodo,
      columns: ToDoFields.values,
      where: '${ToDoFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ToDo.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<ToDo>> readAllToDos() async {
    final db = await instance.database;
    final orderBy = '${ToDoFields.title} ASC';
    final result = await db.query(tableTodo, orderBy: orderBy);

    return result.map((json) => ToDo.fromJson(json)).toList();
  }

  Future<int> update(ToDo todo) async {
    final db = await instance.database;

    return db.update(
      tableTodo,
      todo.toJson(),
      where: '${ToDoFields.id} = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTodo,
      where: '${ToDoFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

const tableTodo = 'todo';
