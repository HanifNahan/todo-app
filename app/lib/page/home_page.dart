import 'package:app/page/add_todo_page.dart';
import 'package:app/page/edit_todo_page.dart';
import 'package:app/component/todo.dart';
import 'package:app/support/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Todo>> _todos;

  @override
  void initState() {
    super.initState();
    _todos = fetchTodos();
  }

  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await API().get('todos/');
      if (response['status']) {
        final List<dynamic> jsonData = response['data'];
        return jsonData
            .map((json) => Todo(
                  id: json['id'],
                  title: json['title'],
                  description: json['description'],
                  status: json['status'],
                  created: DateTime.parse(json['created']),
                  updated: DateTime.parse(json['updated']),
                ))
            .toList();
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: FutureBuilder<List<Todo>>(
        future: _todos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                final createdFormatted =
                    DateFormat('MMM dd, yyyy').add_jm().format(todo.created);
                final updatedFormatted =
                    DateFormat('MMM dd, yyyy').add_jm().format(todo.updated);
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todo.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                todo.description,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text(
                                    'Status:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: todo.status == 'todo'
                                          ? Colors.orange
                                          : Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      todo.status.toString().split('.').last,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Created:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    createdFormatted,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Updated:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    updatedFormatted,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditTodoPage(todo: todo),
                                ),
                              ).then((value) {
                                if (value == true) {
                                  setState(() {
                                    _todos = fetchTodos();
                                  });
                                }
                              });
                            },
                            icon: const Icon(Icons.edit),
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoPage()),
          ).then((value) {
            if (value == true) {
              setState(() {
                _todos = fetchTodos();
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
