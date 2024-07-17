import 'dart:math';

import 'package:flutter/material.dart';

class ArrowBox extends StatelessWidget {
  final int index;
  final double width;
  final double height;
  final double overlapFactor;
  final String texte;
  final String link;

  const ArrowBox({super.key, required this.index, required this.width, required this.height, required this.overlapFactor, required this.texte, required this.link});

Widget build(BuildContext context) {
  Color? color = Colors.blue[(index) * 200 + 100];

  return Stack(
    children: [
      SizedBox(
        width: width,
        height: height,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onHover: (value) {
              color = value ? Colors.blue[(index) * 200 + 200] : Colors.blue[(index) * 200 + 100];
            },
            onTap: () {
                color = const Color.fromARGB(255, 10, 46, 74);
              // Naviguez vers une autre page
              Navigator.pushNamed(
                context,
                '/$link',
              );
            },
            child: Ink.image(
              image: const AssetImage('assets/arrow.png'),
              colorFilter: ColorFilter.mode(color!, BlendMode.modulate),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      SizedBox(
        width: width,
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB((width+50) * (1-overlapFactor), 0, 0, 0),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: CircleAvatar(
                  radius: width/10,
                  backgroundColor: Colors.white,
                  child: Text('${index + 1}', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: max(10, width/15 + 6)),),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Text(texte, style: TextStyle(color: const Color.fromRGBO(0, 0, 0, 1), fontSize: max(10, width/15 + 6))),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

  
}