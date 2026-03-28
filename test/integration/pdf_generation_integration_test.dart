import 'dart:async';
import 'dart:io';

import 'package:contrapp/create_pdf.dart';
import 'package:contrapp/main.dart' as app;
import 'package:contrapp/object/contract_calendar.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/machine.dart';
import 'package:contrapp/object/operation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    app.resetAppData();
    app.oldContractPaths = {};
    app.equipPicked.equipList = [];
    app.selectedCalendar = <String, Map<String, dynamic>>{};
  });

  test(
    'createPdfFromMarkdown writes a non empty pdf with the expected file name in Contrat',
    () async {
      final tempDir = await _createTempWorkspace('pdf_generation');
      final originalCurrentDirectory = Directory.current;

      try {
        Directory.current = tempDir;

        app.variablesContrat['entreprise'] = 'Client PDF';
        app.variablesContrat['adresse1'] = '5 avenue du Test';
        app.variablesContrat['adresse2'] = '69000 Lyon';
        app.variablesContrat['capital'] = '10000';
        app.variablesContrat['matricule'] = 'PDF123';
        app.variablesContrat['date'] = '20/03/2026';
        app.variablesContrat['versionContrat'] = 4;
        app.customTva = 20;
        app.montantAstreinte = 0;
        app.tauxHoraire = 100;
        app.attachList = [];

        app.equipPicked.equipList = [
          Equipment(
            equipName: 'Vitrine murale',
            operations: [
              Operation(
                operationName: 'Entretien trimestriel',
                visits: 4,
                defaultSelected: true,
              ),
            ],
            machines: [
              Machine(
                information: 'Carrier - Magasin',
                number: 1,
                visitsPerYear: 4,
                minutesExpected: 60,
              ),
            ],
          ),
        ];

        app.selectedCalendar = {
          'Vitrine murale': {
            'months': {
              for (final month in calendarMonths)
                month: month == 'Jan' || month == 'Jul',
            },
            'operations': {
              'Entretien trimestriel': {
                for (final month in calendarMonths)
                  month: month == 'Jan' || month == 'Jul',
              },
            },
          },
        };

        app.recomputeContractTotalsFromMachines();

        final expectedPdf = File(
          '${tempDir.path}${Platform.pathSeparator}Contrat${Platform.pathSeparator}${app.generateNomFichier()}.pdf',
        );

        await _runPdfCreationAndWait(expectedPdf);

        expect(await expectedPdf.exists(), isTrue);

        final pdfBytes = await expectedPdf.readAsBytes();
        expect(pdfBytes, isNotEmpty);
        expect(String.fromCharCodes(pdfBytes.take(4)), '%PDF');
        expect(await expectedPdf.length(), greaterThan(1000));
      } finally {
        Directory.current = originalCurrentDirectory;
        await _deleteIfExists(tempDir);
      }
    },
  );
}

Future<void> _runPdfCreationAndWait(File expectedPdf) async {
  final errorCompleter = Completer<Object>();

  runZonedGuarded(
    createPdfFromMarkdown,
    (error, _) {
      if (!errorCompleter.isCompleted) {
        errorCompleter.complete(error);
      }
    },
  );

  final creationFuture = _waitForFile(expectedPdf);
  final errorFuture = errorCompleter.future.then<void>((error) => throw error);

  await Future.any([creationFuture, errorFuture]);
}

Future<void> _waitForFile(File file) async {
  final deadline = DateTime.now().add(const Duration(seconds: 30));

  while (DateTime.now().isBefore(deadline)) {
    if (await file.exists() && await file.length() > 0) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  throw TimeoutException('Timed out while waiting for PDF generation.');
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
