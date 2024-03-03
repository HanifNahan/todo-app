import 'dart:convert';

import 'package:app/page/add_todo_page.dart';
import 'package:app/component/todo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditTodoPage extends StatefulWidget {
  final Todo todo;
  const EditTodoPage({Key? key, required this.todo}) : super(key: key);

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TodoStatus _selectedStatus;

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

  Future<void> _updateTodo() async {
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

    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/todos/${widget.todo.id}/update/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(todoData),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update todo: ${response.body}'),
        ),
      );
    }
  }

  Future<void> _deleteTodo() async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/todos/${widget.todo.id}/delete/'),
    );

    if (response.statusCode == 204) {
      Navigator.pop(context, true);
    } else if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todo item does not exist'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete todo'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: Padding(
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
            DropdownButton<TodoStatus>(
              value: _selectedStatus,
              onChanged: (newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
              items: TodoStatus.values.map((status) {
                return DropdownMenuItem<TodoStatus>(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updateTodo();
                  },
                  child: const Text('Update Todo'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _deleteTodo();
                  },
                  child: const Text('Delete Todo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
