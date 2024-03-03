/*
 * Class: Todo
 * Description: This class represents a todo item with its properties.
 */
class Todo {
  final int id; // Unique identifier for the todo.
  final String title; // Title of the todo.
  final String description; // Description of the todo.
  final String status; // Status of the todo (e.g., "todo" or "completed").
  final DateTime created; // Date and time when the todo was created.
  final DateTime updated; // Date and time when the todo was last updated.

  /*
   * Constructor: Todo
   * Description: Initializes a Todo object with the given properties.
   * Parameters:
   *   - id: Unique identifier for the todo.
   *   - title: Title of the todo.
   *   - description: Description of the todo.
   *   - status: Status of the todo.
   *   - created: Date and time when the todo was created.
   *   - updated: Date and time when the todo was last updated.
   */
  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.created,
    required this.updated,
  });
}
