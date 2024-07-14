
import 'package:flutter/material.dart';
import 'button/arrow_box.dart';

class Navbare extends StatelessWidget {
  final double overlapFactor = 0.9;
  final int arrowNumber = 5;

  const Navbare({super.key});
  
  @override
  Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final totalWidth = constraints.maxWidth/overlapFactor;
      final arrowWidth = totalWidth / arrowNumber;
      final overlap = arrowWidth * overlapFactor;
      return Center(
        child: Stack(
          children: List.generate(arrowNumber, (index) => Positioned(
            left: index * (arrowWidth)* overlapFactor,
            width: arrowWidth,
            child: ArrowBox(index: index, width: arrowWidth),
          )).reversed.toList(),
        ),
      );
    },
  );
}
}