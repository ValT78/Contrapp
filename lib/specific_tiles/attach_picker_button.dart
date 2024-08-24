import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:contrapp/common_tiles/bouncy_action_button.dart';

class AttachPickerButton extends StatelessWidget {
  final List<String> attachList;
  final VoidCallback onPickPhotos;

  const AttachPickerButton({
    super.key,
    required this.attachList,
    required this.onPickPhotos,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1000,
          margin: const EdgeInsets.fromLTRB(30, 50, 30, 10),
          child: TravelButton(
            color: Colors.amber,
            icon: Icons.attach_file,
            label: 'Ajouter une Image',
            actionFunction: onPickPhotos,
            height: 300,
            roundedBorder: 30,
            textSize: 80,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          width: 1400,
          height: 300,
          child: Center(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: attachList.isNotEmpty && attachList.length <= 4 ? 1.2 : 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: attachList.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  child: Image.memory(
                    base64Decode(attachList[index]),
                    fit: BoxFit.fill,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
