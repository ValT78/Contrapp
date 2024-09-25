import 'dart:math';

import 'package:contrapp/specific_tiles/image_holder.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/common_tiles/bouncy_action_button.dart';

class AttachPickerButton extends StatefulWidget {
  final List<String> attachList;
  final VoidCallback onPickPhotos;

  const AttachPickerButton({
    super.key,
    required this.attachList,
    required this.onPickPhotos,
  });

  @override
  AttachPickerButtonState createState() => AttachPickerButtonState();
}

class AttachPickerButtonState extends State<AttachPickerButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(30, 50, 30, 10),
          child: TravelButton(
            color: Colors.amber,
            icon: Icons.attach_file,
            label: 'Ajouter une Image',
            actionFunction: widget.onPickPhotos,
            height: max( 300* MediaQuery.of(context).size.width / 1920, 300),
            width: 1000,
            roundedBorder: 30,
            textSize: 100,
            scaleWidthFactor: 1,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          width: 1400,
          height: 400,
          child: Center(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: widget.attachList.isNotEmpty && widget.attachList.length <= 5 ? 1 : 1.5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: widget.attachList.length,
              itemBuilder: (context, index) {
                return ImageHolder(
                  imageData: widget.attachList[index],
                  onDelete: () {
                    setState(() {
                      widget.attachList.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
