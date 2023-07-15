import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> todoList = [];
  final List<TodoItem> completedList = [];

  void _addTodoItem(String todo) {
    setState(() {
      final currentTime = DateTime.now();
      final formattedTime =
          '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}';
      todoList.add(TodoItem(todo: todo, time: formattedTime));
    });
  }

  void _toggleTodoComplete(int index) {
    setState(() {
      final todo = todoList[index];
      todo.isComplete = !todo.isComplete;
      if (todo.isComplete) {
        completedList.add(todo);
        todoList.removeAt(index);
      }
    });
  }

  void _removeTodoItem(int index, bool isCompleted) {
    setState(() {
      if (isCompleted) {
        completedList.removeAt(index);
      } else {
        todoList.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          final todo = todoList[index];
          return ListTile(
            leading: todo.isComplete
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.radio_button_unchecked),
            title: Text(todo.todo),
            subtitle: Text(todo.time),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _removeTodoItem(index, false);
              },
            ),
            onTap: () {
              _toggleTodoComplete(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final todo = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoScreen()),
          );
          if (todo != null) {
            _addTodoItem(todo);
          }
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Completed',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CompletedListScreen(completedList)),
            );
          }
        },
      ),
    );
  }
}

class AddTodoScreen extends StatelessWidget {
  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _todoController,
              decoration: InputDecoration(
                labelText: 'Todo',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final todo = _todoController.text.trim();
                Navigator.pop(context, todo);
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class CompletedListScreen extends StatelessWidget {
  final List<TodoItem> completedList;

  CompletedListScreen(this.completedList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: ListView.builder(
        itemCount: completedList.length,
        itemBuilder: (context, index) {
          final completedTodo = completedList[index];
          return ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text(completedTodo.todo),
            subtitle: Text(completedTodo.time),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Navigator.pop(context, index);
              },
            ),
          );
        },
      ),
    );
  }
}

class TodoItem {
  final String todo;
  final String time;
  bool isComplete;

  TodoItem({required this.todo, required this.time, this.isComplete = false});
}
