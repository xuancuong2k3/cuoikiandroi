class Task {
  String title;
  String description;
  bool completed;

  Task(
      {required this.title, required this.description, this.completed = false});
}