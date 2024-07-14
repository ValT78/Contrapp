
import 'dart:math';

import 'package:flutter/material.dart';
import 'button/arrow_box.dart';

class Navbare extends StatelessWidget {

  final double overlapFactor = 0.88;
  final int arrowNumber = 5;
  final double height = 70;
  final List<String> textes = ['Information', 'Equipement', 'Calendrier', 'Pièce-Jointe', 'Récapitulatif'];
  
  Navbare({super.key});
  
  @override
  Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final totalWidth = constraints.maxWidth;
      final buttonWidth = min(totalWidth * 0.3 / 3, 100).toDouble() ;
      final arrowWidth = (totalWidth - buttonWidth*3) / arrowNumber ;
      final overlap = (1 - overlapFactor)*arrowWidth;
  
      
      return Column(
  children: [
    Center(
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                color: Colors.blue[100], // Ajoutez votre couleur de fond ici
                child: SizedBox(
                  height: height,
                  width: buttonWidth,
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Image.asset('assets/smallLogo.png', fit: BoxFit.contain, height: height/2, width: buttonWidth,),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: List.generate(arrowNumber, (index) => Positioned(
                  left: index * arrowWidth - overlap,
                  height: height,
                  width: arrowWidth / overlapFactor,

                  child: ArrowBox(index: index, width: arrowWidth / overlapFactor, height: height, overlapFactor: overlapFactor, texte: textes[index]),
                )).reversed.toList(),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                color: Colors.blue[900], // Ajoutez votre couleur de fond ici
                child: SizedBox(
                  height: height,
                  width: buttonWidth,
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Button 1'),
                    ),
                  ),
                ),
              ),
            ),
              Align(
              alignment: Alignment.center,
              child: Container(
                color: Colors.blue[900], // Ajoutez votre couleur de fond ici
                child: SizedBox(
                  height: height,
                  width: buttonWidth,
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Button 1'),
                    ),
                  ),
                ),
              ),
              )
          ],
        ),
      ),
    ),
  ],
);
    },
  );
}

}