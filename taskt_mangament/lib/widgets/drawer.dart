import 'package:flutter/material.dart';
import 'package:taskt_mangament/widgets/add_task_page.dart';
import 'package:taskt_mangament/widgets/add_task_page.dart';

class Drawers extends StatelessWidget {

  // void _openAddTaskPage() async {
  //   final newTask = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => AddTaskPage(addTaskCallback: (newTask) {
  //               setState(() {
  //                 tasks.add(newTask);
  //               });
  //             })),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: const <Widget>[
        DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Home',
              style: TextStyle(color: Colors.green),
            )),
        ListTile(
          title: Text('Home'),
          // onTap: _openAddTaskPage(),
        ),
        ListTile(
          title: Text('Home'),
        ),
        ListTile(
          title: Text('Home'),
        ),
      ],
    ));
  }
}
