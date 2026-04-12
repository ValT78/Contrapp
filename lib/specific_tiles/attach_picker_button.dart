import 'dart:math';

import 'package:contrapp/specific_tiles/image_holder.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/common_tiles/bouncy_action_button.dart';

class AttachPickerButton extends StatefulWidget {
  final List<String> imageList;
  final VoidCallback onPickPhotos;

  const AttachPickerButton({
    super.key,
    required this.imageList,
    required this.onPickPhotos,
  });

  @override
  AttachPickerButtonState createState() => AttachPickerButtonState();
}

class AttachPickerButtonState extends State<AttachPickerButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 16, 10, 10),
          child: TravelButton(
            color: Colors.amber,
            icon: Icons.attach_file,
            label: 'Ajouter une image',
            actionFunction: widget.onPickPhotos,
            height: max(180 * MediaQuery.of(context).size.width / 1920, 150),
            width: 900,
            roundedBorder: 30,
            textSize: 52,
            scaleWidthFactor: 2,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final crossAxisCount = max(1, (availableWidth / 170).floor());

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: widget.imageList.length,
                itemBuilder: (context, index) {
                  return AspectRatio(
                    aspectRatio: 1,
                    child: ImageHolder(
                      imageData: widget.imageList[index],
                      onDelete: () {
                        setState(() {
                          widget.imageList.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
