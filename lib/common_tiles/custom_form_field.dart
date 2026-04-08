import 'package:flutter/material.dart';

class CustomFormField<T> extends StatefulWidget {
  final MaterialColor color;
  final IconData icon;
  final double textSize;
  final double? height;
  final double? width;
  final bool textAlign;
  final String? label;
  final String? hintText;
  final double horizontalMargin;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  final T initValue;
  final ValueChanged<T> onChanged;

  final void Function(TextEditingController)? onTap;

  const CustomFormField(
      {super.key,
      required this.color,
      required this.icon,
      required this.textSize,
      this.height,
      this.width,
      this.textAlign = false,
      this.label,
      this.hintText,
      required this.onChanged,
      required this.initValue,
      this.horizontalMargin = 0,
      this.onTap,
      this.focusNode,
      this.controller});

  static FormFieldState? of(BuildContext context) =>
      context.findAncestorStateOfType<FormFieldState>();

  @override
  FormFieldState<T> createState() => FormFieldState<T>();
}

class FormFieldState<T> extends State<CustomFormField<T>> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  late final bool _ownsTextController;
  late final bool _ownsFocusNode;

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _ownsTextController = widget.controller == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _textController = widget.controller ?? TextEditingController();
    _textController.text = widget.initValue.toString();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _textController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _textController.text.length,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nextValue = widget.initValue.toString();
    if (oldWidget.initValue != widget.initValue &&
        _textController.text != nextValue) {
      _textController.text = nextValue;
    }
  }

  @override
  void dispose() {
    if (_ownsTextController) {
      _textController.dispose();
    }
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: widget.width,
      height: widget.height,
      margin: EdgeInsets.symmetric(horizontal: widget.horizontalMargin),
      decoration: BoxDecoration(
        color: widget.color[100]!.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextFormField(
        controller: _textController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: widget.textSize * 0.75,
            fontWeight: FontWeight.bold,
            color: widget.color[900]!.withValues(alpha: 0.7),
          ),
          labelText: widget.label,
          labelStyle: TextStyle(
            fontSize: widget.textSize / 2,
            fontWeight: FontWeight.bold,
            color: widget.color[600],
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color[900]!,
              width: 3.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color[700]!,
              width: 2.0,
            ),
          ),
          prefixIcon: Icon(
            widget.icon,
            color: widget.color[900],
            size: widget.textSize,
          ),
          // contentPadding: const EdgeInsets.only(left: 5),
        ),
        textAlign: widget.textAlign ? TextAlign.center : TextAlign.left,
        cursorColor: widget.color[900], // Set cursor color to green
        style: TextStyle(
          fontSize: widget.textSize * 0.75,
          fontWeight: FontWeight.bold,
          color: widget.color[900]!,
        ),
        onChanged: _whenFieldChanged,
        onTap:
            widget.onTap != null ? () => widget.onTap!(_textController) : null,
      ),
    );
  }

  void _whenFieldChanged(String value) {
    if (T == int) {
      int? parsedValue = int.tryParse(value);
      widget.onChanged((parsedValue ?? 0) as T);
    } else if (T == double) {
      double? parsedValue = double.tryParse(value);
      widget.onChanged((parsedValue ?? 0.0) as T);
    } else {
      widget.onChanged(value as T);
    }
  }
}
