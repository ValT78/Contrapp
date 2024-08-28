import 'dart:convert';
import 'package:flutter/material.dart';

class ImageHolder extends StatefulWidget {
  final String imageData;
  final VoidCallback onDelete;

  const ImageHolder({
    super.key,
    required this.imageData,
    required this.onDelete,
  });

  @override
  ImageHolderState createState() => ImageHolderState();
}

class ImageHolderState extends State<ImageHolder> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onDelete,
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              child: Image.memory(
                base64Decode(widget.imageData),
                fit: BoxFit.fill,
              ),
            ),
            if (isHovered)
              Center(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 30,
                    ),
                    onPressed: widget.onDelete,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

