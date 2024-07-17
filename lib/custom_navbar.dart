import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'button/arrow_box.dart';

class CustomNavbar extends StatefulWidget {
  final double height;

  const CustomNavbar({super.key, required this.height});

  @override
  _CustomNavbarState createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scale;
  late Animation<Color?> _color;

  final double overlapFactor = 0.88;
  final int arrowNumber = 5;
  final List<String> textes = ['Information', 'Equipement', 'Calendrier', 'Pièce-Jointe', 'Récapitulatif'];
  final List<String> link = ['common', 'equip', 'calendar', 'attach', 'recap'];
  
  _CustomNavbarState();
  
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 30),
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
                            onPressed: () {},
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.save, color: Colors.black), // Icone de sauvegarde
                                  Text('Save', style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1),)), // Texte "Save"
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
                            onPressed: () {
                              showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Voulez-vous vraiment quitter ?'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  const SizedBox(height: 10), // Espacement entre les boutons
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.yellow,
                                      minimumSize: const Size(200, 50), // Taille du bouton
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Annuler', style: TextStyle(fontSize: 20, color: Colors.black)),
                                  ),
                                  const SizedBox(height: 10), // Espacement entre les boutons
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      minimumSize: const Size(200, 50), // Taille du bouton
                                    ),
                                    onPressed: () {
                                      // Insérez ici le code pour sauvegarder les données
                                      SystemNavigator.pop();
                                    },
                                    child: const Text('Sauvegarder et Quitter', style: TextStyle(fontSize: 20, color: Colors.black)),
                                  ),
                                  const SizedBox(height: 10), // Espacement entre les boutons
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      minimumSize: const Size(200, 50), // Taille du bouton
                                    ),
                                    onPressed: () {
                                      SystemNavigator.pop();
                                    },
                                    child: const Text('Quitter', style: TextStyle(fontSize: 20, color: Colors.black)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                            },
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.exit_to_app, color: Colors.black), // Icone pour quitter
                                  Text('Quit', style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1),)), // Texte "Quitter"
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


@override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
