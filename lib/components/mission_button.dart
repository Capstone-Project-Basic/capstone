import 'package:flutter/material.dart';

class MissionGradeButton extends StatelessWidget {
  final String grade;
  final Color color;
  final VoidCallback buttonFunction;

  const MissionGradeButton({required this.grade, required this.color, required this.buttonFunction});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: buttonFunction,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
      ),
      child: Text(
        grade,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}