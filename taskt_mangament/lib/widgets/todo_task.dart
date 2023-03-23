import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoTask extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final String taskDescription;
  Function(bool?)? onChanged;
  final DateTime dateTime;
  VoidCallback? deleteFunction;
  VoidCallback? editFunction;

  ToDoTask({
    super.key,
    required this.taskName,
    required this.taskDescription,
    required this.taskCompleted,
    required this.onChanged,
    required this.dateTime,
    required this.deleteFunction,
    required this.editFunction,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
    String subtitleText = 'Deadline: $formattedDate \n$taskDescription';
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color(0xFF363636),
      ),
      margin: EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        leading: Checkbox(
          value: taskCompleted,
          shape: CircleBorder(),
          onChanged: onChanged,
          checkColor: Color(0xFF363636),
        ),
        title: Text(taskName, style: TextStyle(color: Colors.white)),
        subtitle: Text(
          subtitleText,
          style: TextStyle(color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: editFunction,
            ),
            IconButton(
              icon: Icon(
              Icons.delete,
              color: Colors.white,
              ),
              onPressed: deleteFunction,
            ),
          ]
        )
      ),
    );
  }
}
