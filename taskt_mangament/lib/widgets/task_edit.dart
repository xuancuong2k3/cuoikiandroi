import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskt_mangament/models/task.dart';

class EditTaskPage extends StatefulWidget {
  final Function(Task) addTaskCallback;

  EditTaskPage({required this.addTaskCallback});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1C),
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Due Date',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              readOnly: true,
              controller: dateController,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2030),
                );
                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    pickedDate = pickedDate.add(Duration(
                      hours: pickedTime.hour,
                      minutes: pickedTime.minute,
                    ));
                    setState(() {
                      selectedDate = pickedDate!;
                      dateController.text = DateFormat.yMd().add_Hm().format(pickedDate);
                    });
                  }
                }
              },
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final String title = titleController.text.trim();
                final String description = descriptionController.text.trim();

                if (title.isNotEmpty) {
                  final Task newTask = Task(
                    title: title,
                    description: description,
                    dateTime: selectedDate,
                  );
                  widget.addTaskCallback(newTask);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B3B3B),
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Color(0xFF5C699F)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
