import 'dart:io';
import 'package:contrapp/main.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:contrapp/common_tiles/bouncy_action_button.dart';
import 'package:image/image.dart' as img;
import 'dart:convert';

class AttachPicker extends StatefulWidget {
  const AttachPicker({super.key});

  @override
  AttachPickerState createState() => AttachPickerState();
}

class AttachPickerState extends State<AttachPicker> {

  Future<void> pickPhotos() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      for (String? path in result.paths) {
        if (path != null) {
          String base64Image = await compressAndConvertToBase64(path);
          setState(() {
            attachList.add(base64Image);
          });
        }
      }
    }
  }

  Future<String> compressAndConvertToBase64(String path) async {
    File file = File(path);
    img.Image? image = img.decodeImage(file.readAsBytesSync());

    // Compresser l'image
    img.Image compressedImage = img.copyResize(image!, width: 800); // Ajustez la taille selon vos besoins

    List<int> compressedBytes = img.encodeJpg(compressedImage, quality: 70); // Ajustez la qualité selon vos besoins
    String base64Image = base64Encode(compressedBytes);
    return base64Image;
  }

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
            actionFunction: pickPhotos,
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