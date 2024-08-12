import 'package:flutter/material.dart';

class SuperTitle extends StatelessWidget {
  final String title;
  final MaterialColor color;
  const SuperTitle({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: color[900],
        fontSize: 50.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
        shadows: const [
          Shadow(
            blurRadius: 10.0,
            color: Colors.black26,
            offset: Offset(5.0, 5.0),
          ),
        ],
        decoration: TextDecoration.underline,
        decorationColor: color[600],
        decorationStyle: TextDecorationStyle.dotted,
      ),
    );
  }
}