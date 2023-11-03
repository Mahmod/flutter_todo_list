import 'package:flutter/material.dart';
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

  void addToDo() {
    if (todoController.text.isNotEmpty) {
      setState(() {
        toDoList.add(ToDo(id: DateTime.now().toString(), title: todoController.text));
        todoController.clear();
      });
    }
  }

  void toggleDone(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
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
                  title: Text(todo.title),
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
