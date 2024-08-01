// main.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pages/home_page.dart';
import 'pages/common_page.dart';
import 'pages/equip_page.dart';
import 'pages/calendar_page.dart';
import 'pages/attach_page.dart';
import 'pages/recap_page.dart';
import 'search/equip_list.dart';
import 'package:provider/provider.dart';


final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  Map<String, dynamic> variablesContrat = {
    'entreprise': '',
    'adresse1': '',
    'adresse2': '',
    'matricule': '',
    'capital': 0,
    'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
    'versionContrat': 1,
    'numeroContrat': '000000001',
    'attachList': <String>[],
    'equipPickedList': <String>[],
    'montantHT': 1255,
    'montantTTC': 1000,
    'astreinte': 'Accès au service de dépannage 24h/24 et 7j/7',
    'prixAstreinte': 'Offerte'
  };


  final List<String> equipToPickList = []; // Votre liste d'équipements

  List<String> get equipPickedList => variablesContrat['equipPickedList'] as List<String>;

  set equipPickedList(List<String> list) {
    variablesContrat['equipPickedList'] = list;
  }

  List<String> get attachList => variablesContrat['attachList'] as List<String>;

  set attachList(List<String> list) {
    variablesContrat['attachList'] = list;
  }


Future<void> _loadAppData() async {
    print(variablesContrat);

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


