import 'dart:convert';

import 'package:app/component/text_input.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum TodoStatus {
  todo,
  completed,
}

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  TodoStatus selectedStatus = TodoStatus.todo;

  Future<void> _createTodo() async {
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
      'status': selectedStatus
          .toString()
          .split('.')
          .last, // Convert enum value to string
    };

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/todos/create/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(todoData),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create todo: ${response.body}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: SingleChildScrollView(
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
            CustomInputField(
              hintText: 'Enter description',
              isMultiline: true,
              controller: descriptionController,
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
                value: selectedStatus,
                onChanged: (newValue) {
                  setState(() {
                    selectedStatus = newValue!;
                  });
                },
                underline: Container(), // Remove the underline
                icon: const Icon(Icons.arrow_drop_down), // Custom dropdown icon
                style: const TextStyle(
                    color: Colors.black), // Custom dropdown text style
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
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _createTodo();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Save Todo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
