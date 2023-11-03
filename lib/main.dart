import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoListScreen(),
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  List<ToDo> toDoList = [];
  TextEditingController todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  void _loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? toDoListString = prefs.getString('toDoList');
    if (toDoListString != null) {
      setState(() {
        toDoList = (json.decode(toDoListString) as List)
            .map((item) => ToDo.fromJson(item))
            .toList();
      });
    }
  }

  void _saveToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String toDoListString = json.encode(toDoList.map((todo) => todo.toJson()).toList());
    await prefs.setString('toDoList', toDoListString);
  }

  void addToDo() {
    if (todoController.text.isNotEmpty) {
      setState(() {
        toDoList.add(ToDo(id: DateTime.now().toString(), title: todoController.text));
        todoController.clear();
      });
      _saveToDoList();
    }
  }

  void toggleDone(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
    _saveToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Column(
        children: [
          TextField(
            controller: todoController,
            decoration: InputDecoration(
              labelText: 'Add a new to-do item',
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: addToDo,
              ),
            ),
            onSubmitted: (value) => addToDo(),
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
                      toggleDone(todo);
                    },
                  ),
                  onLongPress: () {
                    setState(() {
                      toDoList.removeAt(index);
                    });
                    _saveToDoList();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
