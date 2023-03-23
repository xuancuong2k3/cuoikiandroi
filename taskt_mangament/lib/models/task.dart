class Task {
  String title;
  String description;
  bool completed;
  DateTime dateTime;

  Task(
      {required this.title, required this.description, required this.dateTime, this.completed = false});
}
