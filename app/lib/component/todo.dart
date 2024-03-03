class Todo {
  final int id;
  final String title;
  final String description;
  final String status;
  final DateTime created;
  final DateTime updated;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.created,
    required this.updated,
  });
}
