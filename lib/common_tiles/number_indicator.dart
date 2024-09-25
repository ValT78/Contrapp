import 'package:flutter/material.dart';

class NumberIndicator extends StatelessWidget {
  final String text;
  final int number;
  final double width;
  final double height;
  final double widthScaleFactor;

  const NumberIndicator({
    super.key,
    required this.text,
    required this.number,
    required this.width,
    this.height = 250.0,
    this.widthScaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    double widthFactor = (1 + (MediaQuery.of(context).size.width - 1920) / 1920 / widthScaleFactor);
    return Container(
      width: width * widthFactor,
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
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.0 * widthFactor,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Text(
              number.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 100.0 * widthFactor,
                fontWeight: FontWeight.bold
              ),
            ),
        ],
      ),
    );
  }
}
