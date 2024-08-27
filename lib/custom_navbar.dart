import 'dart:math';

import 'package:flutter/material.dart';
import 'specific_tiles/arrow_box.dart';
import 'package:contrapp/main.dart';

class CustomNavbar extends StatefulWidget {
  final double height;

  const CustomNavbar({super.key, required this.height});

  @override
  CustomNavbarState createState() => CustomNavbarState();
}

class CustomNavbarState extends State<CustomNavbar> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scale;
  late Animation<Color?> _color;

  final double overlapFactor = 0.88;
  final int arrowNumber = 5;
  final List<String> textes = ['Information', 'Equipement', 'Calendrier', 'Pièce-Jointe', 'Récapitulatif'];
  final List<String> link = ['common', 'equip', 'calendar', 'attach', 'recap'];
    
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );

    _scale = Tween<double>(begin: 1.0, end: 1.0).animate(_controller);
    _color = ColorTween(begin: Colors.blue[100], end: Colors.blue[100]).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {

  double height = widget.height;

  return LayoutBuilder(
    builder: (context, constraints) {
      final totalWidth = constraints.maxWidth-8;
      final buttonWidth = min(totalWidth * 0.3 / 3, 100).toDouble() ;
      final arrowWidth = (totalWidth - buttonWidth*3) / arrowNumber ;
      final overlap = (1 - overlapFactor)*arrowWidth;
  
      
      return Column(
        children: [
          Center(
            child: SizedBox(
              height: height,
              child: Container(
                color: const Color.fromARGB(255, 8, 46, 102),
                child: Row(
                children: [
                  MouseRegion(
                    onHover: (event) {
                      _scale = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
                      _color = ColorTween(begin: Colors.blue[100], end: Colors.blue[200]).animate(_controller);
                      _controller.forward();
                    },
                    onExit: (event) {
                      _controller.reverse();
                    },
                    child: GestureDetector(
                      onTapDown: (details) {
                        _scale = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
                        _color = ColorTween(begin: Colors.blue[200], end: Colors.blue[300]).animate(_controller);
                        _controller.forward();
                      },
                      onTapUp: (details) {
                        _controller.reverse();
                        Navigator.pushNamed(context, '/home');
                      },
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scale.value,
                            child: Container(
                              height: 100, // Ajustez la hauteur comme vous le souhaitez
                              width: 100, // Ajustez la largeur comme vous le souhaitez
                              color: _color.value, // Ajoutez votre couleur de fond ici
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: Image.asset('assets/smallLogo.png', fit: BoxFit.fill),
                                    ),
                                    const Center(
                                      child: Icon(Icons.home, size: 50,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: List.generate(arrowNumber, (index) => Positioned(
                        left: index * arrowWidth - overlap,
                        height: height,
                        width: arrowWidth / overlapFactor,

                        child: ArrowBox(index: index, width: arrowWidth / overlapFactor, height: height, overlapFactor: overlapFactor, texte: textes[index], link: link[index]),
                      )).reversed.toList(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      color: const Color.fromARGB(255, 8, 46, 102),
                      child: SizedBox(
                        height: height,
                        width: buttonWidth,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Colors.green.shade900; // Couleur lorsqu'on clique sur le bouton
                                  } else if (states.contains(WidgetState.hovered)) {
                                    return Colors.green.shade700; // Couleur lorsqu'on passe dessus
                                  }
                                  return Colors.green; // Couleur par défaut
                                },
                              ),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.black, width: 3), // Bordure noire
                                ),
                              ),
                            ),
                            onPressed: () {
                              saveContract();
                            },
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.save, color: Colors.black, size: 30,), // Icone de sauvegarde
                                  Text('Save', style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontWeight: FontWeight.bold, fontSize: 19)), // Texte "Save"
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      color: const Color.fromARGB(255, 8, 46, 102),
                      child: SizedBox(
                        height: height,
                        width: buttonWidth,
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Colors.red.shade900; // Couleur lorsqu'on clique sur le bouton
                                  } else if (states.contains(WidgetState.hovered)) {
                                    return Colors.red.shade700; // Couleur lorsqu'on passe dessus
                                  }
                                  return Colors.red; // Couleur par défaut
                                },
                              ),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.black, width: 3), // Bordure noire
                                ),
                              ),
                            ),
                            onPressed: () async {
                              bool shouldReset = await _showResetDialog(context);
                              if (shouldReset) {
                                resetAppData();
                                Navigator.pushNamed(context, '/home');
                              }
                            },
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.refresh, color: Colors.black, size: 35,), // Icone pour quitter
                                  Text('Reset', style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontWeight: FontWeight.bold, fontSize: 15)), // Texte "Quitter"
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<bool> _showResetDialog(BuildContext context) async {
  final widthScreen = MediaQuery.of(context).size.width;
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 14),
              Text('Voulez-vous recommencer ?', style: TextStyle(fontSize: 60 * widthScreen/1920, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30), // Espacement entre les boutons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  minimumSize: Size(1500, 100 * widthScreen/1920), // Taille du bouton
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Annuler', style: TextStyle(fontSize: 50 * widthScreen/1920, color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(1500, 100 * widthScreen/1920), // Taille du bouton
                ),
                onPressed: () async {
                  await saveContract();
                  Navigator.of(context).pop(true);
                },
                child: Text('Sauvegarder et recommencer', style: TextStyle(fontSize: 50 * widthScreen/1920, color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(1500, 100 * widthScreen/1920), // Taille du bouton
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Recommencer', style: TextStyle(fontSize: 50 * widthScreen/1920, color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    },
  ) ?? false; // Retourne false si le dialogue est fermé sans sélection
}



@override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
