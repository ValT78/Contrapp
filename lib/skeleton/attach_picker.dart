import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'package:contrapp/main.dart'; // Assurez-vous que le chemin est correct
import 'package:contrapp/specific_tiles/attach_picker_button.dart'; // Assurez-vous que le chemin est correct

class AttachPicker extends StatefulWidget {
  const AttachPicker({super.key});

  @override
  AttachPickerContainerState createState() => AttachPickerContainerState();
}

class AttachPickerContainerState extends State<AttachPicker> {

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
    return AttachPickerButton(
      attachList: attachList,
      onPickPhotos: pickPhotos,
    );
  }
}
