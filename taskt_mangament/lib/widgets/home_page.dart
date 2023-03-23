import 'package:flutter/material.dart';
import 'package:taskt_mangament/widgets/drawer.dart';
import 'package:taskt_mangament/widgets/task_completed.dart';
import 'package:taskt_mangament/widgets/todo_task.dart';
import 'add_task_page.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [
    Task(title: "Task 1", description: "Description 1", dateTime: DateTime.now()),
    Task(title: "Task 2", description: "Description 2", dateTime: DateTime.now()),
    Task(title: "Task 3", description: "Description 3", dateTime: DateTime.now()),
  ];

  List<Task> completedTasks = [];

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }
  void deleteTaskCompleted(int index) {
    setState(() {
      completedTasks.removeAt(index);
    });
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].completed = !tasks[index].completed;
      if (tasks[index].completed) {
        completedTasks.add(tasks[index]);
        tasks.removeAt(index);
      }
    });
  }

  void toggleTaskCompletion2(int index) {
    setState(() {
      completedTasks[index].completed = !completedTasks[index].completed;
      if (!completedTasks[index].completed) {
        tasks.add(completedTasks[index]);
        completedTasks.removeAt(index);
      }
    });
  }

  void _openAddTaskPage() async {
    final newTask = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddTaskPage(addTaskCallback: (newTask) {
                setState(() {
                  tasks.add(newTask);
                });
              })),
    );
  }

  @override
  Widget build(BuildContext context) {
    tasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return Scaffold(
      drawer: Drawers(),
      backgroundColor: Color(0xFF1C1C1C),
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tasks',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF788CDE),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ToDoTask(
                    taskName: tasks[index].title,
                    taskDescription: tasks[index].description,
                    taskCompleted: tasks[index].completed,
                    onChanged: (value) => toggleTaskCompletion(index),
                    deleteFunction: () {
                      deleteTask(index);
                    },
                    dateTime: tasks[index].dateTime,
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Tasks Completed',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF788CDE),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: completedTasks.length,
                itemBuilder: (context, index) {
                  return TaskCompleted(
                    taskName: completedTasks[index].title,
                    taskDescription: completedTasks[index].description,
                    taskCompleted: completedTasks[index].completed,
                    onChanged: (value) => toggleTaskCompletion2(index),
                    deleteFunction: () {
                      deleteTaskCompleted(index);
                    },
                    dateTime: completedTasks[index].dateTime,
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _openAddTaskPage,
              child: Text('Add Task',style: TextStyle(color: Color(0xFF5C699F)),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B3B3B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
