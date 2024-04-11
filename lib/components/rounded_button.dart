import 'package:flutter/material.dart';
import 'package:pocekt_teacher/constants.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.color,
    required this.title,
    required this.buttonFunction,
    required this.subTitle,
  });

  final Color color;
  final String title;
  final String subTitle;
  final VoidCallback buttonFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: buttonFunction,
          minWidth: double.infinity,
          height: 42.0,
          child: RichText(
            text: TextSpan(style: kSmallText, children: [
              TextSpan(text: title),
              TextSpan(
                  text: subTitle,
                  style: const TextStyle(
                    color: children_dark,
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
