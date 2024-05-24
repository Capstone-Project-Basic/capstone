import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
  });

  final String title;
  final String content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: actions,
        content: Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ));
  }
}
