import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TravelButton extends StatefulWidget {
  final MaterialColor color;
  final IconData icon;
  final String label;
  final double height;
  final double roundedBorder;
  final double textSize;
  final String? link;
  final Function? actionFunction;

  const TravelButton({super.key, required this.color, required this.icon, required this.label, required this.height, required this.roundedBorder, required this.textSize, this.link, this.actionFunction});

  static TravelButtonState? of(BuildContext context) => context.findAncestorStateOfType<TravelButtonState>();

  @override
  TravelButtonState createState() => TravelButtonState();
}

class TravelButtonState extends State<TravelButton> {

  bool _isHoveringButton = false;
    
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
      onEnter: (PointerEnterEvent event) => setState(() => _isHoveringButton = true),
      onExit: (PointerExitEvent event) => setState(() => _isHoveringButton = false),
      child: AnimatedContainer(
        height: _isHoveringButton ? widget.height : widget.height * 0.9,
        transform: _isHoveringButton ? Matrix4.translationValues(0, -widget.height * 0.1, 0) : Matrix4.translationValues(0, 0, 0),
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return widget.color[700]!; // couleur plus foncée quand la souris passe dessus
                }
                return widget.color; // couleur d'origine
              },
            ),
            shadowColor: WidgetStateProperty.all<Color>(Colors.black), // ombre
            side: WidgetStateProperty.all<BorderSide>(const BorderSide(color: Colors.white, width: 2.0)), // bordure
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.roundedBorder),
              ),
            ),
            elevation: WidgetStateProperty.all<double>(10.0),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            overlayColor: WidgetStateProperty.all<Color>(widget.color[100]!), // couleur quand on clique sur le bouton
          ),
          icon: Icon(widget.icon, size: widget.textSize * 2),
          label: Center(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.label,
                style: TextStyle(fontSize: widget.textSize, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          onPressed: () async {
            if (widget.actionFunction != null) {
              await widget.actionFunction!();
            }
            if (widget.link != null) {
              Navigator.pushNamed(context, widget.link!);
            }
          },
        ),
      ),
    ),
    );
  }
}
