/*
 * File: button_primary.dart
 * Description: This file contains the ButtonPrimary widget, which represents a primary button.
 */

import 'package:flutter/material.dart'; // Importing Flutter Material library.

/*
 * Class: ButtonPrimary
 * Description: This class represents a primary button widget.
 */
class ButtonPrimary extends StatelessWidget {
  final VoidCallback
      onPressed; // Callback function to be called when the button is pressed.
  final Color? bgColor; // Background color of the button (optional).
  final Widget child; // Child widget of the button.

  /*
   * Constructor: ButtonPrimary
   * Description: Initializes a ButtonPrimary object with the given parameters.
   * Parameters:
   *   - onPressed: Callback function to be called when the button is pressed.
   *   - child: Child widget of the button.
   *   - bgColor: Background color of the button (optional).
   */
  const ButtonPrimary({
    Key? key,
    required this.onPressed,
    required this.child,
    this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double
          .infinity, // Making the button expand to the full width of its parent.
      child: ElevatedButton(
        onPressed: onPressed, // Assigning the onPressed callback function.
        style: ElevatedButton.styleFrom(
          backgroundColor:
              bgColor, // Setting the background color of the button.
          padding: const EdgeInsets.symmetric(
              vertical: 16), // Setting padding for the button.
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10), // Setting border radius for the button.
          ),
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: bgColor != null
                ? Colors.white
                : null, // Setting text color based on background color.
          ),
          child: child, // Assigning the child widget of the button.
        ),
      ),
    );
  }
}
