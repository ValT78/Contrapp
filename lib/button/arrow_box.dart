import 'package:flutter/material.dart';

class ArrowBox extends StatelessWidget {
  final int index;
  final double width;
  final double height;
  final double overlapFactor;
  final String texte;

  const ArrowBox({super.key, required this.index, required this.width, required this.height, required this.overlapFactor, required this.texte});

  @override
Widget build(BuildContext context) {
  return Stack(
      children: [
        SizedBox(
          width: width,
          height: height,
         child: Image.asset('assets/arrow.png', color: Colors.blue[(index) * 200 + 100], fit: BoxFit.fill,)
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
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('${index + 1}', style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),),
              ),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Text(texte, style: const TextStyle(color: Colors.white, fontSize: 20),),
        )],
        ),
        ),
      ],
  );
}

}