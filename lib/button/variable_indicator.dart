import 'package:flutter/material.dart';

class VariableIndicator<T> extends StatefulWidget {
  final MaterialColor color;
  final IconData icon;
  final double textSize;
  final double? width;
  final double? height;

  final ValueNotifier<T> variableNotifier;


const VariableIndicator({
    super.key,
    required this.color,
    required this.icon,
    required this.textSize,
    this.width,
    this.height,
    required this.variableNotifier,
  });

  static VariableIndicatorState? of(BuildContext context) => context.findAncestorStateOfType<VariableIndicatorState>();

  @override
  VariableIndicatorState<T> createState() => VariableIndicatorState<T>();
}

class VariableIndicatorState<T> extends State<VariableIndicator<T>> {
    
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: BoxDecoration(
        color: widget.color[200],
        borderRadius: BorderRadius.circular(80),
        border: Border.all(
          color: widget.color[800]!,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<dynamic>(
            valueListenable: widget.variableNotifier,
            builder: (context, value, child) {
                return Text(
                value.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: widget.textSize,
                  fontWeight: FontWeight.bold,
                  color: widget.color[800]!,
                ),
                );
            },
          ),
          Icon(
            widget.icon,
            color: widget.color[800]!,
            size: widget.textSize,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.variableNotifier.dispose();
    super.dispose();
  }
}