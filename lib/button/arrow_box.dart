import 'package:flutter/material.dart';

class ArrowBox extends StatelessWidget {
  final int index;
  final double width;

  const ArrowBox({super.key, required this.index, required this.width});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/arrow.png', color: Colors.blue[(index + 1) * 100], height: 100, width: width,),
        Positioned(
          top: 10,
          left: 10,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text('${index + 1}'),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Text('Texte ${index + 1}', style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}