/*
 * File: edit_todo_page.dart
 * Description: This file contains the EditTodoPage widget, which allows users to edit existing todos.
 */

import 'package:app/component/button/button_primary.dart'; // Importing the ButtonPrimary widget.
import 'package:app/component/todo.dart'; // Importing the Todo class.
import 'package:app/page/add_todo_page.dart';
import 'package:app/support/api.dart'; // Importing the API class for making HTTP requests.
import 'package:flutter/material.dart'; // Importing Flutter Material library.

/*
 * Class: EditTodoPage
 * Description: This class represents the page where users can edit existing todos.
 */
class EditTodoPage extends StatefulWidget {
  final Todo todo; // The todo object to be edited.
  const EditTodoPage({Key? key, required this.todo}) : super(key: key);

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

/*
 * Class: _EditTodoPageState
 * Description: This class represents the state of the EditTodoPage widget.
 */
class _EditTodoPageState extends State<EditTodoPage> {
  late TextEditingController
      _titleController; // Controller for the title text field.
  late TextEditingController
      _descriptionController; // Controller for the description text field.
  late TodoStatus _selectedStatus; // The selected status of the todo.

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController =
        TextEditingController(text: widget.todo.description);
    _selectedStatus = _getStatusFromString(widget.todo.status);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /*
   * Function: _getStatusFromString
   * Description: Helper function to convert a status string to TodoStatus enum.
   * Parameters:
   *   - statusString: The status string to be converted.
   * Returns: The corresponding TodoStatus enum.
   */
  TodoStatus _getStatusFromString(String statusString) {
    switch (statusString.toLowerCase()) {
      case 'todo':
        return TodoStatus.todo;
      case 'completed':
        return TodoStatus.completed;
      default:
        throw Exception('Invalid status string: $statusString');
    }
  }

  /*
   * Function: _updateTodo
   * Description: Function to update the todo on the server.
   */
  Future<void> _updateTodo() async {
    try {
      final String title = _titleController.text.trim();
      final String description = _descriptionController.text.trim();

      if (title.isEmpty || description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Title or description cannot be empty'),
          ),
        );
        return;
      }

      final Map<String, dynamic> todoData = {
        'id': widget.todo.id,
        'title': title,
        'description': description,
        'status': _selectedStatus.toString().split('.').last,
      };

      final response =
          await API().put('todos/${widget.todo.id}/update/', todoData);
      if (response['status']) {
        back();
      } else {
        _showSnackBar('Failed to update todo: ${response['data'].toString()}');
      }
    } catch (e) {
      _showSnackBar('Failed to update todo: ${e.toString()}');
    }
  }

  /*
   * Function: _deleteTodo
   * Description: Function to delete the todo from the server.
   */
  Future<void> _deleteTodo() async {
    try {
      final response = await API().delete('todos/${widget.todo.id}/delete/');

      if (response['status']) {
        back();
      } else {
        _showSnackBar('Failed to delete todo');
      }
    } catch (e) {
      _showSnackBar('Failed to delete todo: ${e.toString()}');
    }
  }

  /*
   * Function: back
   * Description: Function to navigate back to the previous screen.
   */
  void back() {
    Navigator.pop(context, true);
  }

  /*
   * Function: _showSnackBar
   * Description: Function to display a SnackBar with the given message.
   * Parameters:
   *   - message: The message to be displayed in the SnackBar.
   */
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Enter description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<TodoStatus>(
                      value: _selectedStatus,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedStatus = newValue!;
                        });
                      },
                      underline: Container(),
                      icon: const Icon(Icons.arrow_drop_down),
                      style: const TextStyle(color: Colors.black),
                      items: TodoStatus.values.map((status) {
                        return DropdownMenuItem<TodoStatus>(
                          value: status,
                          child: Text(
                            status.toString().split('.').last,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonPrimary(
                  onPressed: () {
                    _updateTodo();
                  },
                  child: const Text('Update Todo'),
                ),
                const SizedBox(height: 8),
                ButtonPrimary(
                  bgColor: Colors.red,
                  onPressed: () {
                    _deleteTodo();
                  },
                  child: const Text('Delete Todo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
