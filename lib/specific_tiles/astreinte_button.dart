import 'dart:math';

import 'package:contrapp/common_tiles/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/main.dart';



class AstreinteButton extends StatefulWidget {
  const AstreinteButton({super.key});

  @override
  AstreinteButtonState createState() => AstreinteButtonState();
}

class AstreinteButtonState extends State<AstreinteButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late FocusNode _textFieldFocusNode;
  late TextEditingController textFieldController;

  bool _isClicked = variablesContrat['hasAstreinte'];

  double storedAstreinte = montantAstreinte;

   @override
  void initState() {
    super.initState();
      _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.3, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _textFieldFocusNode = FocusNode();
    textFieldController = TextEditingController(text: variablesContrat['montantAstreinte'].toString());
    _textFieldFocusNode.addListener(() {
    if (_textFieldFocusNode.hasFocus) {
      textFieldController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: textFieldController.text.length,
      );
    }
  });

    if(_isClicked) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthFactor = (MediaQuery.of(context).size.width/ 1920);
    return ClipRect(
      child: SizedBox(
        width: 430 * widthFactor,
        height: max(100* widthFactor, 100),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              left: _isClicked ? 230 * widthFactor : 0,
              child: CustomFormField(
                color: Colors.green,
                icon: Icons.euro,
                textSize: 57.0 * widthFactor,
                onChanged: (value) {
                  montantAstreinte = value;
                  storedAstreinte = value;
                },
                height: max(100* widthFactor, 100),
                width: 200 * widthFactor,
                initValue: montantAstreinte,
                label: 'Montant',
                )
            ),
            SlideTransition(
              position: _offsetAnimation,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isClicked = !_isClicked;
                    variablesContrat['hasAstreinte'] = _isClicked;
                    if (_isClicked) {
                      _controller.forward();
                      _textFieldFocusNode.requestFocus();
                      montantAstreinte = storedAstreinte;
                    } else {
                      _controller.reverse();
                      _textFieldFocusNode.unfocus();
                      montantAstreinte = 0.0;
                    }
                  });
                },
                child: Material(
                  color: Colors.transparent, // Pour que le Material soit transparent
                  child: Container(
                    width: 330 * widthFactor,
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Ajouter des bords arrondis
                      color: _isClicked ? Colors.green[600] : Colors.deepOrangeAccent[700],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Ajout de cette ligne
                      children: [
                        Icon(
                          _isClicked ? Icons.check_box_rounded : Icons.access_time_rounded,
                          color: Colors.white,
                          size: 60.0 * widthFactor,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          'Astreinte\n   24/24',
                          style: TextStyle(
                            fontSize: 30.0 * widthFactor, // Augmenter la taille du texte entré
                            color: Colors.white, // Changer la couleur du texte entré en magenta
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )

            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}