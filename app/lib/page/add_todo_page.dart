import 'package:app/component/button/button_primary.dart';
import 'package:app/component/text_input.dart';
import 'package:app/support/api.dart';
import 'package:flutter/material.dart';

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

      final response = await API().post('todos/create/', todoData);
      if (response['status']) {
        back();
      } else {
        _showSnackBar('Failed to create todo: ${response['data'].toString()}');
      }
    } catch (e) {
      _showSnackBar('Failed to create todo: ${e.toString()}');
    }
  }

  void back() {
    Navigator.pop(context, true);
  }

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
        title: const Text('Add Todo'),
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
            child: ButtonPrimary(
              onPressed: () {
                _createTodo();
              },
              child: const Text('Save Todo'),
            ),
          ),
        ],
      ),
    );
  }
}
