import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? bgColor;
  final Widget child;

  const ButtonPrimary({
    Key? key,
    required this.onPressed,
    required this.child,
    this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        // Use a conditional expression to set the text color
        // to white if bgColor is provided, otherwise use the
        // default text color of ElevatedButton
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: bgColor != null ? Colors.white : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
