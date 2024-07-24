// main.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/common_page.dart';
import 'pages/equip_page.dart';
import 'pages/calendar_page.dart';
import 'pages/attach_page.dart';
import 'pages/recap_page.dart';
import 'package:contrapp/create_pdf.dart' as pdf;
import 'search/equip_list.dart';
import 'package:provider/provider.dart';


final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

String entreprise = '';
String adresse1 = '';
String adresse2 = '';
String matricule = '';
int capital = 0;
DateTime date = DateTime.now();
int versionContrat = 1;

final List<String> equipToPickList = []; // Votre liste d'équipements
List<String> equipPickedList = []; // La deuxième liste

Future<void> _loadAppData() async {
  Directory projectDir = Directory.current;
    List<FileSystemEntity> files = projectDir.listSync(recursive: false);
    File? targetFile;

    for (var file in files) {
      if (file is File && file.path.endsWith('.contrapp')) {
      targetFile = file;
      break;
      }
    }

    if(targetFile != null) {
      String jsonData = await targetFile.readAsString();
      Map<String, dynamic> data = jsonDecode(jsonData);

      equipToPickList.addAll(List<String>.from(data['equipToPickList']));
    }
  }


void main() {
  _loadAppData();
  runApp(ChangeNotifierProvider(
      create: (context) => EquipList(),
      child: const MyApp(),
    ),);
  pdf.createPdfFromMarkdown();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/common': (context) => const CommonPage(),
        '/equip': (context) => const EquipPage(),
        '/calendar': (context) => const CalendarPage(),
        '/attach': (context) => const AttachPage(),
        '/recap': (context) => const RecapPage(),
      },
      
    );
  }

  
}


