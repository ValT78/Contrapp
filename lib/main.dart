// main.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:contrapp/object/equipment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pages/home_page.dart';
import 'pages/common_page.dart';
import 'pages/equip_page.dart';
import 'pages/calendar_page.dart';
import 'pages/attach_page.dart';
import 'pages/recap_page.dart';
import 'object/equip_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:file_picker/file_picker.dart';


final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final ValueNotifier<double> tauxHoraireNotifier = ValueNotifier<double>(0);

  final ValueNotifier<double> hoursOfWorkNotifier = ValueNotifier<double>(0);


  // Montant HT (et TTC) du contrat
  final ValueNotifier<int> montantHTNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> montantTTCNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> totalHTNotifier = ValueNotifier<int>(0);

  double get tauxHoraire {
    return variablesContrat['tauxHoraire'];
  }

  set tauxHoraire(double value) {
    variablesContrat['tauxHoraire'] = value;
    tauxHoraireNotifier.value = value;
  }

  double get montantHT {
    return variablesContrat['montantHT'];
  }
  
  set montantHT(double value) {
    variablesContrat['montantHT'] = value;
    montantHTNotifier.value = value.ceil();
    totalHT = value+montantAstreinte;
    montantTTC = totalHTNotifier.value * (1+variablesContrat['customTva']/100) as double;
  }

  double get montantAstreinte {
    return variablesContrat['montantAstreinte'];
  }
  
  set montantAstreinte(double value) {
    variablesContrat['montantAstreinte'] = value;
    totalHT = value+montantHT;
    montantTTC = totalHTNotifier.value * (1+variablesContrat['customTva']/100) as double;
  }
  
  set totalHT(double value) {
    totalHTNotifier.value = value.ceil();
     variablesContrat['totalHT'] = value;
  }

  double get customTva {
    return variablesContrat['customTva'];
  }
  
  set customTva(double value) {
    variablesContrat['customTva'] = value;
    montantTTC= totalHTNotifier.value * (1+value/100);
  }

  set montantTTC(double value) {
    montantTTCNotifier.value = value.ceil();
    variablesContrat['montantTTC'] = value;
  }
  
  EquipList equipToPick = EquipList(isModifyingApp: true); // Votre liste d'équipements
  EquipList equipPicked = EquipList(); // Votre liste d'équipements sélectionnés

  Map<String, Map<String, bool>> get selectedCalendar => variablesContrat['selectedCalendar'] as Map<String, Map<String, bool>>;

  set selectedCalendar(Map<String, Map<String, bool>> calendar) {
    variablesContrat['selectedCalendar'] = calendar;
  }


  // Liste des photos à attacher
  List<String> get attachList => variablesContrat['attachList'] as List<String>;

  set attachList(List<String> list) {
    variablesContrat['attachList'] = list;
  }

  bool hasCustomTva = false;

  Map<String, dynamic> variablesContrat = resetVariablesContrat();

  Map<String, dynamic> resetVariablesContrat() {
  return {
    'entreprise': '',
    'adresse1': '',
    'adresse2': '',
    'matricule': '',
    'capital': '',
    'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
    'versionContrat': 1,
    'attachList': <String>[],
    'equipPicked': <Equipment>[],
    'montantHT': 0.0,
    'montantTTC': 0.0,
    'totalHT': 0.0,
    'customTva': 20.0,
    'hasAstreinte': false,
    'hasCustomTva': false,
    'montantAstreinte': 0.0,
    'tauxHoraire': 0.0,
    'selectedCalendar': <String, Map<String, bool>>{},
    };
  }

  void resetAppData() {
    variablesContrat = resetVariablesContrat();
    equipPicked.equipList.clear();
    attachList.clear();
    montantHT = 0.0;
    montantTTC = 0.0;
    totalHT = 0.0;
    tauxHoraire = 0.0;
    hoursOfWorkNotifier.value = 0.0;
    // for (var equip in equipPicked.equipList) {
    //   for (var machine in equip.machines) {
    //     machine.hoursExpectedNotifier.value = machine.minutesExpected * machine.number * machine.visitsPerYear/60;
    //     machine.priceNotifier.value = (tauxHoraire * machine.hoursExpectedNotifier.value).ceil();
    //     montantHT += machine.priceNotifier.value;
    //     hoursOfWorkNotifier.value += machine.hoursExpectedNotifier.value;
    //   }
    // }
  }

  


// Charger les données de l'application
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
      try {
        Map<String, dynamic> data = jsonDecode(jsonData);
        equipToPick.equipList.addAll(List<Equipment>.from(data['equipToPick'].map((e) => Equipment.fromJson(e))));

      } catch (e) {
        // Handle decoding error
        print('Error decoding JSON data: $e');
      }

    }
  }

  
  // Fonction pour sauvegarder les données
  Future<void> saveContract() async {
    
    String jsonData = jsonEncode(variablesContrat);

    String? filePath  = await FilePicker.platform.saveFile(
      dialogTitle: 'Sauvegarder le contrat',
      type: FileType.custom,
      allowedExtensions: ['cntrt'],
      fileName: '${generateNomFichier()}.cntrt', // Set the suggested file name here
    );
  

    if (filePath != null) {

      // Vérifiez si le fichier a l'extension .cntrt
      if (!filePath.endsWith('.cntrt')) {
        filePath += '.cntrt';
      }

      File file = File(filePath);
      await file.writeAsString(jsonData);
    }
  }
  

  String generateNumeroContrat() {
  final elements = variablesContrat['date'].split('/');
  String version = variablesContrat['versionContrat'].toString().padLeft(3, '0');
  
  return '${elements[2].padLeft(2)}${elements[1]}${elements[0]}$version';
}

  String generateNomFichier() {
    return '${variablesContrat['entreprise']}-${generateNumeroContrat()}';
  }

Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 2,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 14),
                const Text('Voulez vous quitter ?', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30), // Espacement entre les boutons
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    minimumSize: const Size(1500, 100), // Taille du bouton
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Annuler', style: TextStyle(fontSize: 60, color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(1500, 100), // Taille du bouton
                  ),
                  onPressed: () async {
                    await saveContract();
                    Navigator.of(context).pop(true);
                    return Future.value(true);
                  },
                  child: const Text('Sauvegarder et Quitter', style: TextStyle(fontSize: 60, color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(1500, 100), // Taille du bouton
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    Future.value(true);
                  },
                  child: const Text('Quitter', style: TextStyle(fontSize: 60, color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    ) ?? false;
  }

  


void main() {
  _loadAppData();
  runApp(ChangeNotifierProvider<EquipList>.value(
      value: equipPicked,
      child: const MyApp(),
    ),
  );
  FlutterWindowClose.setWindowShouldCloseHandler(() async {
    bool shouldClose = await _showExitDialog(navigatorKey.currentContext!);
    return shouldClose;
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        fontFamily: 'Gotham',
      ),
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


