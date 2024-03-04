/*
 * File: main.dart
 * Description: This file contains the main entry point of the Flutter application.
 * It initializes the app and sets up the initial screen to be displayed.
 */

import 'package:app/page/home_page.dart'; // Importing the home page widget.
import 'package:flutter/material.dart'; // Importing Flutter Material library.
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp()); // Running the Flutter application.
}

/*
 * Class: MyApp
 * Description: This class represents the main application widget.
 */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /*
   * Function: build
   * Description: This function builds the UI of the application.
   * Parameters:
   *   - context: The BuildContext of the application.
   * Returns: A MaterialApp widget representing the entire application.
   */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disabling debug banner.
      title: 'Flutter Demo', // Setting the title of the app.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple), // Defining color scheme.
        useMaterial3: true, // Enabling Material3 design.
      ),
      home: const HomePage(), // Setting the initial screen to the home page.
    );
  }
}
