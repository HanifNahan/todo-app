/*
 * File: custom_input_field.dart
 * Description: This file contains the CustomInputField widget, which represents a custom text input field.
 */

import 'package:flutter/material.dart'; // Importing Flutter Material library.

/*
 * Class: CustomInputField
 * Description: This class represents a custom text input field widget.
 */
class CustomInputField extends StatelessWidget {
  final String hintText; // Hint text to be displayed in the input field.
  final bool
      isMultiline; // Indicates whether the input field is multiline or not.
  final TextEditingController? controller; // Controller for the input field.

  /*
   * Constructor: CustomInputField
   * Description: Constructs a new instance of CustomInputField.
   * Parameters:
   *   - hintText: The hint text to be displayed in the input field.
   *   - isMultiline: Indicates whether the input field is multiline or not. Default is false.
   *   - controller: The controller for the input field. Default is null.
   */
  const CustomInputField({
    required this.hintText,
    this.isMultiline = false,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Setting the controller for the input field.
      decoration: InputDecoration(
        hintText: hintText, // Setting the hint text for the input field.
        filled: true,
        fillColor:
            Colors.grey[200], // Setting the fill color of the input field.
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none, // Hiding the border of the input field.
        ),
      ),
      maxLines: isMultiline
          ? 4
          : 1, // Setting the maximum number of lines for the input field.
      style: const TextStyle(
          fontSize: 16), // Setting the font size of the input field text.
    );
  }
}
