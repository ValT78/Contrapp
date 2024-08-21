import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:contrapp/main.dart';



class AstreinteButton extends StatefulWidget {
  const AstreinteButton({super.key});

  @override
  AstreinteButtonState createState() => AstreinteButtonState();
}

class AstreinteButtonState extends State<AstreinteButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late FocusNode textFieldFocusNode;
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

    textFieldFocusNode = FocusNode();
    textFieldController = TextEditingController(text: variablesContrat['montantAstreinte'].toString());

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
              child: Container(
                height: 100,
                width: 200,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green[50], // Changer la couleur de fond en magenta
                  borderRadius: BorderRadius.circular(10), // Ajouter des bords arrondis
                ),
                child: TextFormField(
                  controller: textFieldController,
                  focusNode: textFieldFocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Montant',
                    labelStyle: TextStyle(
                      fontSize: 20.0, // Augmenter la taille du label
                      fontWeight: FontWeight.bold, // Mettre le label en gras
                      color: Colors.green[600], // Changer la couleur du label en magenta
                    ),
                    prefixIcon: Icon(Icons.euro, color: Colors.green[600], size: 60.0), // Changer la couleur et la taille de l'icône en magenta
                  ),
                  style: TextStyle(
                    fontSize: 30.0, // Augmenter la taille du texte entré
                    color: Colors.green[800], // Changer la couleur du texte entré en magenta
                    fontWeight : FontWeight.bold
                  ),
                   onChanged: (value) {
                    if (value.isNotEmpty && int.tryParse(value) != null) {
                      variablesContrat['montantAstreinte'] = int.parse(value);
                    }
                  },
                  onFieldSubmitted: (term){
                    // Lorsque vous appuyez sur Entrée, il passe au champ suivant
                    textFieldFocusNode.unfocus();
                  },
                ),
              ),
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
                      textFieldFocusNode.requestFocus();
                    } else {
                      _controller.reverse();
                      textFieldFocusNode.unfocus();
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