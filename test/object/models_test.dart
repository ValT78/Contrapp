import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/machine.dart';
import 'package:contrapp/object/operation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Business objects', () {
    test(
      'machine operation and equipment JSON round trips preserve business data',
      () {
        final equipment = Equipment(
          equipName: 'Chambre froide',
          operations: [
            Operation(
              operationName: 'Entretien',
              visits: 3,
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

        final rebuilt = Equipment.fromJson(equipment.toJson());

        expect(rebuilt.equipName, 'Chambre froide');
        expect(rebuilt.operationsNotifier.value, hasLength(1));
        expect(
          rebuilt.operationsNotifier.value.first.operationNameNotifier.value,
          'Entretien',
        );
        expect(rebuilt.operationsNotifier.value.first.visits, 3);
        expect(rebuilt.operationsNotifier.value.first.defaultSelected, isTrue);
        expect(rebuilt.machines, hasLength(1));
        expect(rebuilt.machines.first.information.value, 'Daikin - Reserve');
        expect(rebuilt.machines.first.number, 2);
        expect(rebuilt.machines.first.visitsPerYear, 4);
        expect(rebuilt.machines.first.minutesExpected, 90);
      },
    );

    test(
      'equipment clone keeps only default selected operations and deep copies machines',
      () {
        final original = Equipment(
          equipName: 'Vitrine',
          operations: [
            Operation(
              operationName: 'Nettoyage',
              visits: 2,
              defaultSelected: true,
            ),
            Operation(
              operationName: 'Option ponctuelle',
              visits: 1,
              defaultSelected: false,
            ),
          ],
          machines: [
            Machine(
              information: 'Carrier - Ligne caisse',
              number: 1,
              visitsPerYear: 2,
              minutesExpected: 60,
            ),
          ],
        );

        final cloned = original.clone();
        cloned.machines.first.number = 9;
        cloned.machines.first.information.value = 'Modifie dans le clone';
        cloned.operationsNotifier.value.first.operationNameNotifier.value =
            'Operation clonee';

        expect(cloned.equipName, original.equipName);
        expect(cloned.operationsNotifier.value, hasLength(1));
        expect(
          cloned.operationsNotifier.value.first.operationNameNotifier.value,
          'Operation clonee',
        );
        expect(
          original.operationsNotifier.value.first.operationNameNotifier.value,
          'Nettoyage',
        );
        expect(original.operationsNotifier.value, hasLength(2));
        expect(cloned.machines.first.number, 9);
        expect(original.machines.first.number, 1);
        expect(
          original.machines.first.information.value,
          'Carrier - Ligne caisse',
        );
      },
    );
  });
}
