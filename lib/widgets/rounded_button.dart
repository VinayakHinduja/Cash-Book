import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {super.key,
      required this.text,
      required this.style,
      required this.color,
      this.onPressed,
      this.splashColor});

  final String text;
  final TextStyle style;
  final Function()? onPressed;
  final Color color;
  final Color? splashColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          splashColor: splashColor,
          minWidth: 130.0,
          height: 40.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Text(text, style: style),
        ),
      ),
    );
  }
}
