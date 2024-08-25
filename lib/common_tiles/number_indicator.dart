import 'package:flutter/material.dart';

class NumberIndicator extends StatelessWidget {
  final String text;
  final int number;
  final double width;
  final double height;

  const NumberIndicator({
    super.key,
    required this.text,
    required this.number,
    required this.width,
    this.height = 250.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.blue[300],
        border: Border.all(
          color: Colors.blue[900]!,
          width: 3.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8), // Increase opacity to make the shadow more visible
            spreadRadius: 10,
            blurRadius: 14,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 100.0,
                fontWeight: FontWeight.bold
              ),
            ),
        ],
      ),
    );
  }
}
