import 'package:contrapp/object/equipment.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class EquipList extends ChangeNotifier {
  final List<Equipment> _equipList = [];
  final bool isModifyingApp;

  EquipList({this.isModifyingApp = false});

  List<Equipment> get equipList => _equipList;

  void add(Equipment equip) {
    _equipList.add(equip);
    notifyListeners();
    if (isModifyingApp) modifyApp();
  }

  void removeName(String equipName) {
    _equipList.removeWhere((element) => element.equipName == equipName);
    notifyListeners();
    if (isModifyingApp) modifyApp();
  }

  void remove(Equipment equip) {
    _equipList.remove(equip);
    notifyListeners();
    if (isModifyingApp) modifyApp();
  }

  // Enregistre les modifications qui ont été effectuées dans la page des équipements de manière définitive
  Future<void> modifyApp() async {
    Map<String, dynamic> data = {
      'equipToPick': _equipList.map((e) => e.toJson()).toList(),
    };

    String jsonData = jsonEncode(data);

    Directory projectDir = Directory.current;
    List<FileSystemEntity> files = projectDir.listSync(recursive: false);
    File? targetFile;

    for (var file in files) {
      if (file is File && file.path.endsWith('.contrapp')) {
      targetFile = file;
      break;
      }
    }

    targetFile ??= File('default.contrapp');
    await targetFile.writeAsString(jsonData);

  }
}

