import 'dart:convert';
import 'dart:io';

import 'package:contrapp/main.dart' as app;
import 'package:contrapp/object/contract_calendar.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/machine.dart';
import 'package:contrapp/object/operation.dart';
import 'package:contrapp/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    app.resetAppData();
    app.oldContractPaths = {};
    app.equipPicked.equipList = [];
    app.equipToPick.equipList = [];
    app.selectedCalendar = <String, Map<String, dynamic>>{};
  });

  test(
    'loading an existing cntrt file hydrates globals normalizes calendar increments version and recomputes totals',
    () async {
      final tempDir = await _createTempWorkspace('contract_load');
      final originalCurrentDirectory = Directory.current;

      try {
        Directory.current = tempDir;

        final equipment = Equipment(
          equipName: 'Centrale frigorifique',
          operations: [
            Operation(
              operationName: 'Entretien annuel',
              visits: 2,
              defaultSelected: true,
            ),
          ],
          machines: [
            Machine(
              information: 'Daikin - Reserve',
              number: 2,
              visitsPerYear: 4,
              minutesExpected: 90,
            ),
          ],
        );

        final contractFile = File(
          '${tempDir.path}${Platform.pathSeparator}contrat_test.cntrt',
        );
        await contractFile.writeAsString(
          jsonEncode({
            'entreprise': 'Client Integration',
            'adresse1': '1 rue des Tests',
            'adresse2': '75000 Paris',
            'matricule': 'RCS123',
            'capital': '50000',
            'date': '15/02/2026',
            'versionContrat': 2,
            'attachList': ['piece_jointe_1'],
            'equipPicked': [equipment.toJson()],
            'montantHT': 0.0,
            'montantTTC': 0.0,
            'totalHT': 0.0,
            'customTva': 10.0,
            'hasAstreinte': true,
            'hasCustomTva': true,
            'montantAstreinte': 50.0,
            'tauxHoraire': 100.0,
            'selectedCalendar': {
              'Centrale frigorifique': {
                'Jan': true,
                'Mar': true,
              },
            },
          }),
        );

        final wasLoaded = await const HomePage().loadContractData(
          contractFile.path,
          null,
        );

        expect(wasLoaded, isTrue);
        expect(app.variablesContrat['entreprise'], 'Client Integration');
        expect(app.attachList, ['piece_jointe_1']);
        expect(app.equipPicked.equipList, hasLength(1));
        expect(
          app.equipPicked.equipList.first.equipName,
          'Centrale frigorifique',
        );
        expect(app.equipPicked.equipList.first.machines, hasLength(1));
        expect(
          app.equipPicked.equipList.first.machines.first.information.value,
          'Daikin - Reserve',
        );

        final equipmentMonths = getEquipmentMonthSelection(
          app.selectedCalendar,
          'Centrale frigorifique',
        );
        final operationMonths = getOperationMonthSelections(
          app.selectedCalendar,
          'Centrale frigorifique',
        );

        expect(equipmentMonths['Jan'], isTrue);
        expect(equipmentMonths['Mar'], isTrue);
        expect(equipmentMonths['Fév'], isFalse);
        expect(operationMonths.keys, ['Entretien annuel']);
        expect(
          hasAnySelectedMonth(operationMonths['Entretien annuel']!),
          isFalse,
        );

        expect(app.variablesContrat['versionContrat'], 3);
        expect(app.hoursOfWorkNotifier.value, 12.0);
        expect(app.montantHTNotifier.value, 1200);
        expect(app.totalHTNotifier.value, 1250);
        expect(app.montantTTCNotifier.value, 1375);
        expect(app.oldContractPaths, hasLength(1));
        expect(app.oldContractPaths.values.single['path'], contractFile.path);

        final persistedAppFile = File(
          '${tempDir.path}${Platform.pathSeparator}default.contrapp',
        );
        expect(await persistedAppFile.exists(), isTrue);
      } finally {
        Directory.current = originalCurrentDirectory;
        await _deleteIfExists(tempDir);
      }
    },
  );
}

Future<Directory> _createTempWorkspace(String name) async {
  final baseDir = Directory(
    'build${Platform.pathSeparator}test_integration',
  ).absolute;
  await baseDir.create(recursive: true);
  final tempDir = Directory(
    '${baseDir.path}${Platform.pathSeparator}${name}_${DateTime.now().microsecondsSinceEpoch}',
  );
  await tempDir.create(recursive: true);
  return tempDir;
}

Future<void> _deleteIfExists(Directory directory) async {
  if (await directory.exists()) {
    await directory.delete(recursive: true);
  }
}
