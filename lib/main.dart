// main.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:contrapp/object/annex.dart';
import 'package:contrapp/object/contract_calendar.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/machine.dart';
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
  totalHT = value + montantAstreinte;
  montantTTC = totalHTNotifier.value * (1 + variablesContrat['customTva'] / 100)
      as double;
}

double get montantAstreinte {
  return variablesContrat['montantAstreinte'];
}

set montantAstreinte(double value) {
  variablesContrat['montantAstreinte'] = value;
  totalHT = value + montantHT;
  montantTTC = totalHTNotifier.value * (1 + variablesContrat['customTva'] / 100)
      as double;
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
  montantTTC = totalHTNotifier.value * (1 + value / 100);
}

set montantTTC(double value) {
  montantTTCNotifier.value = value.ceil();
  variablesContrat['montantTTC'] = value;
}

EquipList equipToPick =
    EquipList(isModifyingApp: true); // Votre liste d'équipements
EquipList equipPicked = EquipList(); // Votre liste d'équipements sélectionnés

SelectedCalendarData get selectedCalendar {
  final rawCalendar = variablesContrat['selectedCalendar'];
  if (rawCalendar is SelectedCalendarData) {
    // Les données sont déjà dans le format attendu. Juste une vérification de type, pas plus de code que ça
    return rawCalendar;
  }

  final normalized = <String, EquipmentCalendarData>{};
  if (rawCalendar is Map) {
    // Si on a les mois pour l'équipement, on vérifie qu'on a aussi les mois pour les opérations, sinon on les ajoute
    for (final entry in rawCalendar.entries) {
      normalized[entry.key.toString()] = entry.value is Map
          ? Map<String, dynamic>.from(entry.value as Map)
          : <String, dynamic>{};
    }
  }

  variablesContrat['selectedCalendar'] = normalized;
  return normalized;
}

set selectedCalendar(SelectedCalendarData calendar) {
  variablesContrat['selectedCalendar'] = calendar;
}

List<String> _normalizeImageList(dynamic rawList) {
  if (rawList is! List) {
    return <String>[];
  }

  return rawList.map((image) => image.toString()).toList();
}

// Liste des photos à attacher
List<String> get imageList {
  final normalized = _normalizeImageList(
      variablesContrat['imageList'] ?? variablesContrat['attachList']);
  variablesContrat['imageList'] = normalized;
  variablesContrat.remove('attachList');
  return normalized;
}

set imageList(List<String> list) {
  variablesContrat['imageList'] = list;
  variablesContrat.remove('attachList');
}

void ensureImageListStructure() {
  imageList = _normalizeImageList(
    variablesContrat['imageList'] ?? variablesContrat['attachList'],
  );
}

ContractAnnex get contractAnnex {
  final rawAnnex = variablesContrat['contractAnnex'];
  if (rawAnnex is ContractAnnex) {
    return rawAnnex;
  }

  final normalized = ContractAnnex.fromJson(rawAnnex);
  variablesContrat['contractAnnex'] = normalized;
  return normalized;
}

set contractAnnex(ContractAnnex annex) {
  variablesContrat['contractAnnex'] = annex;
}

void ensureContractAnnexStructure() {
  final rawAnnex = variablesContrat['contractAnnex'];
  if (rawAnnex is ContractAnnex) {
    return;
  }

  contractAnnex = ContractAnnex.fromJson(rawAnnex);
}

Map<String, Map<String, String>> oldContractPaths = {};

List<String> equipInformations = [];

const String contractorAddressLineDelimiter = '|';

List<String> contractorAddresses = <String>[];

String _initialContractorAddressSelection() {
  return contractorAddresses.isNotEmpty ? contractorAddresses.first : '';
}

String normalizeContractorAddress(String value) {
  return value
      .replaceAll('\r\n', contractorAddressLineDelimiter)
      .replaceAll('\n', contractorAddressLineDelimiter)
      .replaceAll('\r', contractorAddressLineDelimiter)
      .split(contractorAddressLineDelimiter)
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .join(' $contractorAddressLineDelimiter ');
}

String formatContractorAddressForContract(String value) {
  return normalizeContractorAddress(value)
      .split(contractorAddressLineDelimiter)
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .join('\n\n');
}

String formatContractorAddressInline(String value) {
  return normalizeContractorAddress(value)
      .split(contractorAddressLineDelimiter)
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .join(', ');
}

void ensureContractorAddressSelection() {
  final currentAddress = normalizeContractorAddress(
    variablesContrat['adressePrestataire']?.toString() ?? '',
  );

  variablesContrat['adressePrestataire'] = currentAddress.isNotEmpty
      ? currentAddress
      : _initialContractorAddressSelection();
}

void selectContractorAddress(String address) {
  variablesContrat['adressePrestataire'] = normalizeContractorAddress(address);
}

Future<bool> addContractorAddress(String address) async {
  final normalizedAddress = normalizeContractorAddress(address);
  if (normalizedAddress.isEmpty) {
    return false;
  }

  if (!contractorAddresses.contains(normalizedAddress)) {
    contractorAddresses.add(normalizedAddress);
  }
  selectContractorAddress(normalizedAddress);
  await modifyApp();
  return true;
}

Future<void> removeContractorAddress(String address) async {
  final normalizedAddress = normalizeContractorAddress(address);
  contractorAddresses.remove(normalizedAddress);

  final currentAddress = normalizeContractorAddress(
    variablesContrat['adressePrestataire']?.toString() ?? '',
  );
  if (currentAddress == normalizedAddress) {
    variablesContrat['adressePrestataire'] =
        _initialContractorAddressSelection();
  }

  await modifyApp();
}

List<String> _loadContractorAddresses(Map<String, dynamic> data) {
  if (!data.containsKey('contractorAddresses')) {
    return <String>[];
  }

  final rawAddresses = data['contractorAddresses'];
  if (rawAddresses is! List) {
    return <String>[];
  }

  final loadedAddresses = <String>[];
  for (final rawAddress in rawAddresses) {
    final normalizedAddress = normalizeContractorAddress(rawAddress.toString());
    if (normalizedAddress.isNotEmpty &&
        !loadedAddresses.contains(normalizedAddress)) {
      loadedAddresses.add(normalizedAddress);
    }
  }

  return loadedAddresses;
}

//Pour ouvrir le bouton s'il y en a
bool hasCustomTva = false;

Map<String, dynamic> variablesContrat = resetVariablesContrat();

Map<String, dynamic> resetVariablesContrat() {
  return {
    'entreprise': '',
    'adresse1': '',
    'adresse2': '',
    'adressePrestataire': _initialContractorAddressSelection(),
    'matricule': '',
    'capital': '',
    'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
    'versionContrat': 1,
    'imageList': <String>[],
    'contractAnnex': ContractAnnex(),
    'equipPicked': <Equipment>[],
    'montantHT': 0.0,
    'montantTTC': 0.0,
    'totalHT': 0.0,
    'customTva': 20.0,
    'hasAstreinte': false,
    'hasCustomTva': false,
    'montantAstreinte': 0.0,
    'tauxHoraire': 0.0,
    'selectedCalendar': <String, Map<String, dynamic>>{},
  };
}

double _roundHours(double value) {
  return double.parse(value.toStringAsFixed(2));
}

void refreshMachineDerivedValues(Machine machine) {
  final hours = _roundHours(
    machine.minutesExpected * machine.number * machine.visitsPerYear / 60,
  );
  machine.hoursExpectedNotifier.value = hours;
  machine.priceNotifier.value = (hours * tauxHoraire).ceil();
}

void recomputeContractTotalsFromMachines() {
  double totalHours = 0;
  double materialAmount = 0;

  for (final equip in equipPicked.equipList) {
    for (final machine in equip.machines) {
      refreshMachineDerivedValues(machine);
      totalHours += machine.hoursExpectedNotifier.value;
      materialAmount += machine.priceNotifier.value;
    }
  }

  hoursOfWorkNotifier.value = _roundHours(totalHours);
  montantHT = materialAmount;
}

void syncContractCalendarWithSelectedEquipments() {
  syncSelectedCalendarWithEquipments(
    selectedCalendar,
    equipPicked.equipList,
  );
}

void updateMachineAndContractTotals(
  Machine machine, {
  int? number,
  int? visitsPerYear,
  int? minutesExpected,
}) {
  final previousHours = machine.hoursExpectedNotifier.value;
  final previousPrice = machine.priceNotifier.value;

  if (number != null) {
    machine.number = number;
  }
  if (visitsPerYear != null) {
    machine.visitsPerYear = visitsPerYear;
  }
  if (minutesExpected != null) {
    machine.minutesExpected = minutesExpected;
  }

  refreshMachineDerivedValues(machine);

  hoursOfWorkNotifier.value = _roundHours(
    hoursOfWorkNotifier.value -
        previousHours +
        machine.hoursExpectedNotifier.value,
  );
  montantHT = montantHT - previousPrice + machine.priceNotifier.value;
}

void resetAppData() {
  variablesContrat = resetVariablesContrat();
  equipPicked.equipList.clear();
  imageList.clear();
  montantHT = 0.0;
  montantTTC = 0.0;
  totalHT = 0.0;
  tauxHoraire = 0.0;
  hoursOfWorkNotifier.value = 0.0;
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

  if (targetFile != null) {
    String jsonData = await targetFile.readAsString();
    try {
      Map<String, dynamic> data = jsonDecode(jsonData);
      equipToPick.equipList.addAll(List<Equipment>.from(
          data['equipToPick'].map((e) => Equipment.fromJson(e))));
      if (data['oldContractPaths'] == null ||
          data['oldContractPaths'].isEmpty) {
        oldContractPaths = {};
      } else {
        oldContractPaths = Map<String, Map<String, String>>.from(
            data['oldContractPaths'].map((key, value) =>
                MapEntry(key, Map<String, String>.from(value))));
      }
      equipInformations = List<String>.from(data['equipInformation'] ?? []);
      contractorAddresses = _loadContractorAddresses(data);
      ensureContractorAddressSelection();
    } catch (e) {
      // Handle decoding error
      print('Error decoding JSON data: $e');
    }
  }
}

// Fonction pour sauvegarder les données
Future<void> saveContract() async {
  syncContractCalendarWithSelectedEquipments();
  variablesContrat['equipPicked'] = equipPicked.equipList;

  String jsonData = jsonEncode(variablesContrat);

  String fileName = generateNomFichier();

  String? filePath = await FilePicker.platform.saveFile(
    dialogTitle: 'Sauvegarder le contrat',
    type: FileType.custom,
    allowedExtensions: ['cntrt'],
    fileName: '$fileName.cntrt', // Set the suggested file name here
  );

  if (filePath != null) {
    // Vérifiez si le fichier a l'extension .cntrt
    if (!filePath.endsWith('.cntrt')) {
      filePath += '.cntrt';
    }

    File file = File(filePath);
    await file.writeAsString(jsonData);
    addContractToHistoric(fileName, filePath);
    modifyApp();
  }
}

void addContractToHistoric(String fileName, String filePath) {
  // Obtenir la date actuelle
  String currentDate = DateTime.now().toIso8601String();

  // Ajouter le fichier avec la date
  oldContractPaths[fileName] = {
    'path': filePath,
    'date': currentDate,
  };

  // Vérifier le nombre de fichiers et supprimer le plus ancien si nécessaire
  if (oldContractPaths.length > 15) {
    // Trouver le fichier le plus ancien
    String oldestFile = oldContractPaths.entries
        .reduce(
            (a, b) => a.value['date']!.compareTo(b.value['date']!) < 0 ? a : b)
        .key;

    // Supprimer le fichier le plus ancien
    oldContractPaths.remove(oldestFile);
  }
}

String generateNumeroContrat() {
  final elements = variablesContrat['date'].split('/');
  String version =
      variablesContrat['versionContrat'].toString().padLeft(3, '0');

  return '${elements[2].substring(2)}${elements[1]}${elements[0]}$version';
}

String generateNomFichier() {
  return '${variablesContrat['entreprise']}-${generateNumeroContrat()}';
}

Future<bool> showExitDialog(BuildContext context) async {
  final widthScreen = MediaQuery.of(context).size.width;
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
                  Text('Voulez vous quitter ?',
                      style: TextStyle(
                          fontSize: 60 * widthScreen / 1920,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30), // Espacement entre les boutons
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      minimumSize: Size(
                          1500, 100 * widthScreen / 1920), // Taille du bouton
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('Annuler',
                        style: TextStyle(
                            fontSize: 60 * widthScreen / 1920,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(
                          1500, 100 * widthScreen / 1920), // Taille du bouton
                    ),
                    onPressed: () async {
                      await saveContract();
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Sauvegarder et Quitter',
                        style: TextStyle(
                            fontSize: 60 * widthScreen / 1920,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(
                          1500, 100 * widthScreen / 1920), // Taille du bouton
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Quitter',
                        style: TextStyle(
                            fontSize: 60 * widthScreen / 1920,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
      ) ??
      false;
}

// Enregistre les modifications qui ont été effectuées dans la page des équipements de manière définitive dans un .contrapp
Future<void> modifyApp() async {
  Map<String, dynamic> data = {
    'equipToPick': equipToPick.equipList.map((e) => e.toJson()).toList(),
    'oldContractPaths': oldContractPaths,
    'equipInformation': equipInformations,
    'contractorAddresses': contractorAddresses,
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

void main() async {
  await _loadAppData();
  runApp(
    ChangeNotifierProvider<EquipList>.value(
      value: equipPicked,
      child: const MyApp(),
    ),
  );
  FlutterWindowClose.setWindowShouldCloseHandler(() async {
    bool shouldClose = await showExitDialog(navigatorKey.currentContext!);
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
