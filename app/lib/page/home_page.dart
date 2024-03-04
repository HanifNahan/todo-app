/*
 * File: home_page.dart
 * Description: This file contains the HomePage widget, which displays the list of todos
 * fetched from the API and allows users to add new todos or edit existing ones.
 */

import 'package:app/component/todo.dart'; // Importing the Todo class.
import 'package:app/page/add_todo_page.dart'; // Importing the AddTodoPage widget.
import 'package:app/page/edit_todo_page.dart'; // Importing the EditTodoPage widget.
import 'package:app/support/api.dart'; // Importing the API class for making HTTP requests.
import 'package:flutter/material.dart'; // Importing Flutter Material library.
import 'package:intl/intl.dart'; // Importing the intl package for date formatting.

/*
 * Class: HomePage
 * Description: This class represents the main page of the application where the list of todos is displayed.
 * It fetches todos from the API, displays them in a ListView, and allows users to add new todos or edit existing ones.
 */
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/*
 * Class: _HomePageState
 * Description: This class represents the state of the HomePage widget.
 */
class _HomePageState extends State<HomePage> {
  late Future<List<Todo>>
      _todos; // Future representing the list of todos fetched from the API.

  @override
  void initState() {
    super.initState();
    _todos = fetchTodos(); // Fetching todos when the widget initializes.
  }

  /*
   * Function: fetchTodos
   * Description: This function fetches the list of todos from the API.
   * Returns: A Future containing a list of todos.
   */
  Future<List<Todo>> fetchTodos() async {
    try {
      final response =
          await API().get('todos/'); // Making a GET request to fetch todos.
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
            .toList(); // Mapping JSON data to Todo objects.
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
        title: const Text('Todo List'), // Setting the title of the app bar.
      ),
      body: FutureBuilder<List<Todo>>(
        future: _todos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Displaying a loading indicator while fetching todos.
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                  'Error: ${snapshot.error}'), // Displaying an error message if fetching fails.
            );
          } else {
            final todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                final createdFormatted = DateFormat('MMM dd, yyyy')
                    .add_jm()
                    .format(todo.created); // Formatting the created date.
                final updatedFormatted = DateFormat('MMM dd, yyyy')
                    .add_jm()
                    .format(todo.updated); // Formatting the updated date.
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
                            icon: const Icon(
                                Icons.edit), // Displaying an edit icon.
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
            MaterialPageRoute(
                builder: (context) =>
                    const AddTodoPage()), // Navigating to the AddTodoPage when the FloatingActionButton is pressed.
          ).then((value) {
            if (value == true) {
              setState(() {
                _todos = fetchTodos();
              });
            }
          });
        },
        child: const Icon(Icons.add), // Displaying a plus icon.
      ),
    );
  }
}
