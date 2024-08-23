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
    return ClipRect(
      child: SizedBox(
        width: 500,
        height: 100,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              left: _isClicked ? 230 : 0,
              child: CustomFormField(
                  color: Colors.green,
                  icon: Icons.euro,
                  textSize: 57.0,
                  onChanged: (value) {
                    if (value.isNotEmpty && int.tryParse(value) != null) {
                      variablesContrat['montantAstreinte'] = int.parse(value);
                    }
                  },
                  height: 100,
                  width: 200,
                initValue: variablesContrat['montantAstreinte'],
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
                    } else {
                      _controller.reverse();
                      _textFieldFocusNode.unfocus();
                    }
                  });
                },
                child: Material(
                  color: Colors.transparent, // Pour que le Material soit transparent
                  child: Container(
                    width: 330,
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Ajouter des bords arrondis
                      color: _isClicked ? Colors.green[600] : Colors.red,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Ajout de cette ligne
                      children: [
                        Icon(
                          _isClicked ? Icons.check_box_rounded : Icons.ads_click_rounded,
                          color: Colors.white,
                          size: 60.0,
                        ),
                        const SizedBox(width: 10.0),
                        const Text(
                          'Astreinte\n   24/24',
                          style: TextStyle(
                            fontSize: 30.0, // Augmenter la taille du texte entré
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