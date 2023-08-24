import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final String text;
  final Color textColor;
  final VoidCallback onPressed;

  CustomButton({
    required this.text,
    this.textColor = Colors.white,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:this.onPressed,
      child: Text(this.text,
        style: TextStyle(
            color: this.textColor,fontSize: 20
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.teal,
        padding: EdgeInsets.fromLTRB(32, 16, 31, 16),
      ),
    );
  }
}
