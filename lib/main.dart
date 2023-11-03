import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'todo.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      // Define the default light theme.
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Define the default dark theme.
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Use the system theme mode.
      themeMode: ThemeMode.system,
      home: ToDoListScreen(),
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final TextEditingController todoController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<ToDo> toDoList = [];

  @override
  void initState() {
    super.initState();
    _refreshToDoList();
  }

  Future _refreshToDoList() async {
    List<ToDo> x = await _dbHelper.readAllToDos();
    setState(() {
      toDoList = x;
    });
  }

  Future _addToDo() async {
    final todo = ToDo(title: todoController.text);
    await _dbHelper.create(todo);
    todoController.clear();
    _refreshToDoList();
  }

  Future _toggleDone(ToDo todo) async {
    todo.isDone = !todo.isDone;
    await _dbHelper.update(todo);
    _refreshToDoList();
  }

  Future _deleteToDo(int id) async {
    await _dbHelper.delete(id);
    _refreshToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: todoController,
              decoration: InputDecoration(
                labelText: 'Add a new to-do item',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addToDo,
                ),
              ),
              onSubmitted: (value) => _addToDo(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: toDoList.length,
              itemBuilder: (context, index) {
                final todo = toDoList[index];
                return ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (bool? value) {
                      _toggleDone(todo);
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteToDo(todo.id!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
