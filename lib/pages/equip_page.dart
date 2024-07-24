import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/search/main_search_bar.dart' as main_search_bar;
import 'package:contrapp/skeleton/selected_equip.dart';
import 'package:contrapp/main.dart';
import 'dart:convert';
import 'dart:io';



class EquipPage extends StatelessWidget {
  const EquipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomNavbar(height: 100,),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Expanded(
                  child: SelectedEquip(),
                ),
              ],
            ),
            main_search_bar.MainSearchBar(),
          ],
        )
      )
    );
  }


  Future<void> modifyApp() async {
    print(equipToPickList);
    Map<String, dynamic> data = {
      'equipToPickList': equipToPickList,
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
    print(targetFile.path);
    await targetFile.writeAsString(jsonData);

  
  }
}