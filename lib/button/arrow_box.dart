import 'dart:math';

import 'package:flutter/material.dart';

class ArrowBox extends StatefulWidget {
  final int index;
  final double width;
  final double height;
  final double overlapFactor;
  final String texte;
  final String link;

  const ArrowBox({super.key, required this.index, required this.width, required this.height, required this.overlapFactor, required this.texte, required this.link});

  @override
  _ArrowBoxState createState() => _ArrowBoxState();
}


class _ArrowBoxState extends State<ArrowBox> {
  bool _hovering = false;

  _ArrowBoxState();

Widget build(BuildContext context) {
  Color? color = Colors.blue[(widget.index) * 200 + 100];

 return MouseRegion(
      onHover: (event) => setState(() => _hovering = true),
      onExit: (event) => setState(() => _hovering = false),
      child: Stack(
        children: [
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  color = const Color.fromARGB(255, 10, 46, 74);
                  Navigator.pushNamed(context, '/${widget.link}');
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  transform: Matrix4.translationValues(_hovering ? -20 : 0, 0, 0),
                  child: Ink.image(
                    image: const AssetImage('assets/arrow.png'),
                    colorFilter: ColorFilter.mode(color!, BlendMode.modulate),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB((widget.width+50) * (1-widget.overlapFactor), 0, 0, 0),
                    child: CircleAvatar(
                      radius: widget.width/10,
                      backgroundColor: Colors.white,
                      child: Text('${widget.index + 1}', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: max(10, widget.width/15 + 6)),),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Text(widget.texte, style: TextStyle(color: const Color.fromRGBO(0, 0, 0, 1), fontSize: max(10, widget.width/15 + 6))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

}

  
}