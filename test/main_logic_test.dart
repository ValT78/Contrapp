import 'package:contrapp/main.dart' as app;
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/machine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    app.resetAppData();
    app.oldContractPaths = {};
    app.equipPicked.equipList = [];
    app.equipToPick.equipList = [];
    app.selectedCalendar = <String, Map<String, dynamic>>{};
  });

  group('Contract totals and identifiers', () {
    test(
      'refreshMachineDerivedValues computes rounded hours and ceiled price from machine settings',
      () {
        final machine = Machine(
          minutesExpected: 95,
          number: 1,
          visitsPerYear: 1,
        );

        app.tauxHoraire = 100;
        app.refreshMachineDerivedValues(machine);

        expect(machine.hoursExpectedNotifier.value, 1.58);
        expect(machine.priceNotifier.value, 158);
      },
    );

    test(
      'recomputeContractTotalsFromMachines aggregates all machines and applies astreinte and TVA',
      () {
        app.tauxHoraire = 100;
        app.customTva = 10;
        app.montantAstreinte = 50;
        app.equipPicked.equipList = [
          Equipment(
            equipName: 'Chambre froide',
            machines: [
              Machine(minutesExpected: 60, number: 2, visitsPerYear: 2),
            ],
          ),
          Equipment(
            equipName: 'Vitrine',
            machines: [
              Machine(minutesExpected: 30, number: 1, visitsPerYear: 4),
            ],
          ),
        ];

        app.recomputeContractTotalsFromMachines();

        expect(app.hoursOfWorkNotifier.value, 6.0);
        expect(app.montantHTNotifier.value, 600);
        expect(app.totalHTNotifier.value, 650);
        expect(app.montantTTCNotifier.value, 716);
        expect(
            app.equipPicked.equipList.first.machines.first.priceNotifier.value,
            400);
        expect(
            app.equipPicked.equipList.last.machines.first.priceNotifier.value,
            200);
      },
    );

    test(
      'updateMachineAndContractTotals updates only the delta of the edited machine',
      () {
        app.tauxHoraire = 100;
        final editedMachine = Machine(
          minutesExpected: 60,
          number: 1,
          visitsPerYear: 1,
        );
        final untouchedMachine = Machine(
          minutesExpected: 60,
          number: 1,
          visitsPerYear: 2,
        );

        app.equipPicked.equipList = [
          Equipment(
            equipName: 'Centrale',
            machines: [editedMachine, untouchedMachine],
          ),
        ];

        app.recomputeContractTotalsFromMachines();
        app.updateMachineAndContractTotals(
          editedMachine,
          number: 3,
          minutesExpected: 30,
        );

        expect(editedMachine.hoursExpectedNotifier.value, 1.5);
        expect(editedMachine.priceNotifier.value, 150);
        expect(untouchedMachine.hoursExpectedNotifier.value, 2.0);
        expect(untouchedMachine.priceNotifier.value, 200);
        expect(app.hoursOfWorkNotifier.value, 3.5);
        expect(app.montantHTNotifier.value, 350);
      },
    );

    test(
      'generateNumeroContrat and generateNomFichier use the contract date version and company name',
      () {
        app.variablesContrat['date'] = '05/09/2026';
        app.variablesContrat['versionContrat'] = 7;
        app.variablesContrat['entreprise'] = 'Client Test';

        expect(app.generateNumeroContrat(), '260905007');
        expect(app.generateNomFichier(), 'Client Test-260905007');
      },
    );

    test(
      'addContractToHistoric keeps only the 15 newest entries when a new contract is added',
      () {
        app.oldContractPaths = {
          for (int i = 0; i < 15; i++)
            'contrat_$i': {
              'path': 'C:/tmp/contrat_$i.cntrt',
              'date':
                  '2026-01-${(i + 1).toString().padLeft(2, '0')}T00:00:00.000',
            },
        };

        app.addContractToHistoric('contrat_recent', 'C:/tmp/recent.cntrt');

        expect(app.oldContractPaths, hasLength(15));
        expect(app.oldContractPaths.containsKey('contrat_0'), isFalse);
        expect(app.oldContractPaths['contrat_recent']?['path'],
            'C:/tmp/recent.cntrt');
      },
    );

    test(
      'resetAppData clears mutable contract state and resets totals',
      () {
        app.variablesContrat['entreprise'] = 'A effacer';
        app.attachList = ['piece-jointe'];
        app.equipPicked.equipList = [
          Equipment(equipName: 'A supprimer', machines: [Machine()]),
        ];
        app.tauxHoraire = 120;
        app.montantAstreinte = 45;
        app.montantHT = 300;
        app.selectedCalendar = {
          'A supprimer': {
            'months': {'Jan': true},
            'operations': <String, Map<String, bool>>{},
          },
        };

        app.resetAppData();

        expect(app.variablesContrat['entreprise'], '');
        expect(app.attachList, isEmpty);
        expect(app.equipPicked.equipList, isEmpty);
        expect(app.selectedCalendar, isEmpty);
        expect(app.tauxHoraire, 0);
        expect(app.montantHTNotifier.value, 0);
        expect(app.totalHTNotifier.value, 0);
        expect(app.montantTTCNotifier.value, 0);
        expect(app.hoursOfWorkNotifier.value, 0.0);
      },
    );
  });
}
