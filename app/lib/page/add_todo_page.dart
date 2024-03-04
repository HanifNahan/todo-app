/*
 * File: add_todo_page.dart
 * Description: This file contains the AddTodoPage widget, which allows users to add new todos.
 */

import 'package:app/component/button/button_primary.dart'; // Importing the ButtonPrimary widget.
import 'package:app/component/text_input.dart'; // Importing the CustomInputField widget.
import 'package:app/support/api.dart'; // Importing the API class for making HTTP requests.
import 'package:flutter/material.dart'; // Importing Flutter Material library.

/*
 * Enum: TodoStatus
 * Description: Enumeration representing the status of a todo.
 */
enum TodoStatus {
  todo,
  completed,
}

/*
 * Class: AddTodoPage
 * Description: This class represents the page where users can add new todos.
 */
class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

/*
 * Class: _AddTodoPageState
 * Description: This class represents the state of the AddTodoPage widget.
 */
class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController titleController =
      TextEditingController(); // Controller for the todo title text field.
  final TextEditingController descriptionController =
      TextEditingController(); // Controller for the todo description text field.
  TodoStatus selectedStatus = TodoStatus.todo; // Selected status for the todo.

  /*
   * Function: _createTodo
   * Description: This function creates a new todo based on user input.
   */
  Future<void> _createTodo() async {
    try {
      final String title = titleController.text.trim();
      final String description = descriptionController.text.trim();

      if (title.isEmpty || description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Title or description cannot be empty'),
          ),
        );
        return;
      }

      final Map<String, dynamic> todoData = {
        'title': title,
        'description': description,
        'status': selectedStatus.toString().split('.').last,
      };

      final response = await API().post('todos/create/',
          todoData); // Making a POST request to create a new todo.
      if (response['status']) {
        back(); // Navigating back to the previous page after successful creation.
      } else {
        _showSnackBar('Failed to create todo: ${response['data'].toString()}');
      }
    } catch (e) {
      _showSnackBar('Failed to create todo: ${e.toString()}');
    }
  }

  /*
   * Function: back
   * Description: This function navigates back to the previous page.
   */
  void back() {
    Navigator.pop(context, true);
  }

  /*
   * Function: _showSnackBar
   * Description: This function displays a snack bar with the given message.
   * Parameters:
   *   - message: The message to be displayed in the snack bar.
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
        title: const Text('Add Todo'), // Setting the title of the app bar.
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
                  CustomInputField(
                    hintText: 'Enter title',
                    controller: titleController,
                  ), // Text field for entering the todo title.
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomInputField(
                    hintText: 'Enter description',
                    isMultiline: true,
                    controller: descriptionController,
                  ), // Text field for entering the todo description.
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
                      value: selectedStatus,
                      onChanged: (newValue) {
                        setState(() {
                          selectedStatus = newValue!;
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
                    ), // Dropdown button for selecting the todo status.
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ButtonPrimary(
              onPressed: () {
                _createTodo(); // Handling the button press to create the todo.
              },
              child: const Text('Save Todo'), // Text displayed on the button.
            ),
          ),
        ],
      ),
    );
  }
}
