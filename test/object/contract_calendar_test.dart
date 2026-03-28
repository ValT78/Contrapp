import 'package:contrapp/object/contract_calendar.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/machine.dart';
import 'package:contrapp/object/operation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Contract calendar normalization', () {
    test(
      'normalizeSelectedCalendar fills missing months and operations from a legacy equipment-only calendar',
      () {
        final equipments = [
          _buildEquipment(
            'Chambre froide',
            operations: ['Entretien', 'Controle etancheite'],
          ),
        ];

        final normalized = normalizeSelectedCalendar({
          'Chambre froide': {
            'Jan': true,
            'Mar': true,
          },
          'Obsolete': {
            'Jan': true,
          },
        }, equipments);

        expect(normalized.keys, ['Chambre froide']);

        final equipmentMonths =
            normalized['Chambre froide']!['months'] as Map<String, bool>;
        expect(equipmentMonths['Jan'], isTrue);
        expect(equipmentMonths['Mar'], isTrue);
        expect(equipmentMonths['Fév'], isFalse);
        expect(equipmentMonths.length, calendarMonths.length);

        final operations = normalized['Chambre froide']!['operations']
            as Map<String, MonthSelection>;
        expect(operations.keys, ['Entretien', 'Controle etancheite']);
        expect(hasAnySelectedMonth(operations['Entretien']!), isFalse);
        expect(
            hasAnySelectedMonth(operations['Controle etancheite']!), isFalse);
      },
    );

    test(
      'normalizeSelectedCalendar keeps declared operation months and ignores unexpected operations',
      () {
        final equipments = [
          _buildEquipment(
            'Vitrine',
            operations: ['Nettoyage', 'Controle'],
          ),
        ];

        final normalized = normalizeSelectedCalendar({
          'Vitrine': {
            'months': {
              'Fév': true,
            },
            'operations': {
              'Nettoyage': {
                'Avr': true,
              },
              'Operation inconnue': {
                'Jan': true,
              },
            },
          },
        }, equipments);

        final equipmentMonths =
            getEquipmentMonthSelection(normalized, 'Vitrine');
        final operationMonths =
            getOperationMonthSelections(normalized, 'Vitrine');

        expect(equipmentMonths['Fév'], isTrue);
        expect(equipmentMonths['Jan'], isFalse);
        expect(operationMonths.keys, ['Nettoyage', 'Controle']);
        expect(operationMonths['Nettoyage']!['Avr'], isTrue);
        expect(hasAnySelectedMonth(operationMonths['Controle']!), isFalse);
      },
    );

    test(
      'normalizeSelectedCalendar returns an empty normalized structure when raw calendar data is invalid',
      () {
        final equipments = [
          _buildEquipment('Congelateur', operations: ['Visite annuelle']),
        ];

        final normalized = normalizeSelectedCalendar('not a map', equipments);

        final equipmentMonths =
            getEquipmentMonthSelection(normalized, 'Congelateur');
        final operationMonths =
            getOperationMonthSelections(normalized, 'Congelateur');

        expect(hasAnySelectedMonth(equipmentMonths), isFalse);
        expect(operationMonths.keys, ['Visite annuelle']);
        expect(
            hasAnySelectedMonth(operationMonths['Visite annuelle']!), isFalse);
      },
    );

    test(
      'syncSelectedCalendarWithEquipments removes obsolete entries and adds missing equipments',
      () {
        final calendar = <String, EquipmentCalendarData>{
          'Ancien equipement': {
            'months': createEmptyMonthSelection(),
            'operations': <String, MonthSelection>{},
          },
        };

        final equipments = [
          _buildEquipment('Meuble 1', operations: ['Nettoyage']),
          _buildEquipment('Meuble 2', operations: ['Controle']),
        ];

        syncSelectedCalendarWithEquipments(calendar, equipments);

        expect(calendar.keys, ['Meuble 1', 'Meuble 2']);
        expect(
          getOperationMonthSelections(calendar, 'Meuble 1').keys,
          ['Nettoyage'],
        );
        expect(
          getOperationMonthSelections(calendar, 'Meuble 2').keys,
          ['Controle'],
        );
      },
    );

    test(
      'getOperationMonthSelection creates an empty operation selection lazily and hasAnySelectedMonth reflects updates',
      () {
        final calendar = <String, EquipmentCalendarData>{};

        final selection = getOperationMonthSelection(
          calendar,
          'Centrale',
          'Controle pression',
        );

        expect(selection.length, calendarMonths.length);
        expect(hasAnySelectedMonth(selection), isFalse);

        selection['Sep'] = true;

        expect(hasAnySelectedMonth(selection), isTrue);
        expect(
          getOperationMonthSelections(calendar, 'Centrale').keys,
          ['Controle pression'],
        );
      },
    );
  });
}

Equipment _buildEquipment(
  String name, {
  List<String> operations = const [],
}) {
  return Equipment(
    equipName: name,
    operations: operations
        .map((operation) => Operation(operationName: operation))
        .toList(),
    machines: [Machine()],
  );
}
