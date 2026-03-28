import 'package:contrapp/main.dart' as app;
import 'package:contrapp/object/contract_calendar.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/machine.dart';
import 'package:contrapp/object/operation.dart';
import 'package:contrapp/skeleton/calendar_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    app.resetAppData();
    app.equipPicked.equipList = [];
    app.selectedCalendar = <String, Map<String, dynamic>>{};
  });

  group('CalendarContainer', () {
    testWidgets(
      'displays selected equipments and synchronizes calendar data on first build',
      (tester) async {
        _useLargeSurface(tester);
        app.equipPicked.equipList = [
          _buildEquipment(
            'Centrale',
            visitsPerYear: 3,
            operations: ['Entretien'],
          ),
          _buildEquipment(
            'Vitrine',
            visitsPerYear: 2,
            operations: ['Controle'],
          ),
        ];
        app.selectedCalendar = {
          'Centrale': {
            'Jan': true,
          },
          'Obsolete': {
            'Jan': true,
          },
        };

        await tester.pumpWidget(_buildTestApp(const CalendarContainer()));
        await tester.pump();

        expect(find.text('Centrale'), findsOneWidget);
        expect(find.text('Vitrine'), findsOneWidget);
        expect(app.selectedCalendar.keys, ['Centrale', 'Vitrine']);
        expect(
          getEquipmentMonthSelection(app.selectedCalendar, 'Centrale')['Jan'],
          isTrue,
        );
        expect(
          getOperationMonthSelections(app.selectedCalendar, 'Centrale').keys,
          ['Entretien'],
        );
        expect(
          getOperationMonthSelections(app.selectedCalendar, 'Vitrine').keys,
          ['Controle'],
        );
      },
    );

    testWidgets(
      'tapping an equipment month cell toggles the selection and updates the total counter',
      (tester) async {
        _useLargeSurface(tester);
        app.equipPicked.equipList = [
          _buildEquipment(
            'Centrale',
            visitsPerYear: 3,
            operations: ['Entretien'],
          ),
        ];

        await tester.pumpWidget(_buildTestApp(const CalendarContainer()));
        await tester.pump();

        expect(find.text('0 / 3'), findsOneWidget);

        await tester.tap(_findMonthCellForTotal('0 / 3', monthIndex: 0));
        await tester.pump();

        expect(
          getEquipmentMonthSelection(app.selectedCalendar, 'Centrale')['Jan'],
          isTrue,
        );
        expect(find.text('✓'), findsOneWidget);
        expect(find.text('1 / 3'), findsOneWidget);

        await tester.tap(_findMonthCellForTotal('1 / 3', monthIndex: 0));
        await tester.pump();

        expect(
          getEquipmentMonthSelection(app.selectedCalendar, 'Centrale')['Jan'],
          isFalse,
        );
        expect(find.text('✓'), findsNothing);
        expect(find.text('0 / 3'), findsOneWidget);
      },
    );

    testWidgets(
      'expands operations on demand and shows a badge when hidden operation dates exist',
      (tester) async {
        _useLargeSurface(tester);
        app.equipPicked.equipList = [
          _buildEquipment(
            'Centrale',
            visitsPerYear: 4,
            operations: ['Nettoyage', 'Controle'],
          ),
        ];

        final nettoyageMonths = createEmptyMonthSelection()..['Jan'] = true;
        final controleMonths = createEmptyMonthSelection()..['Mar'] = true;
        app.selectedCalendar = {
          'Centrale': {
            'months': createEmptyMonthSelection(),
            'operations': {
              'Nettoyage': nettoyageMonths,
              'Controle': controleMonths,
            },
          },
        };

        await tester.pumpWidget(_buildTestApp(const CalendarContainer()));
        await tester.pump();

        expect(find.text('Nettoyage'), findsNothing);
        expect(find.text('Controle'), findsNothing);
        expect(find.text('2'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.expand_more));
        await tester.pump();

        expect(find.byIcon(Icons.expand_less), findsOneWidget);
        expect(find.text('Nettoyage'), findsOneWidget);
        expect(find.text('Controle'), findsOneWidget);
        expect(find.text('2'), findsNothing);

        await tester.tap(find.byIcon(Icons.expand_less));
        await tester.pump();

        expect(find.text('Nettoyage'), findsNothing);
        expect(find.text('Controle'), findsNothing);
        expect(find.text('2'), findsOneWidget);
      },
    );
  });
}

Widget _buildTestApp(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox.expand(child: child),
    ),
  );
}

Equipment _buildEquipment(
  String name, {
  required int visitsPerYear,
  List<String> operations = const [],
}) {
  return Equipment(
    equipName: name,
    operations: operations
        .map((operation) => Operation(operationName: operation, visits: 1))
        .toList(),
    machines: [
      Machine(
        visitsPerYear: visitsPerYear,
      ),
    ],
  );
}

Finder _findMonthCellForTotal(String totalText, {required int monthIndex}) {
  final dataRow = find.ancestor(
    of: find.text(totalText),
    matching: find.byWidgetPredicate(
      (widget) => widget is Row && widget.children.length == 14,
    ),
  ).first;

  return find.descendant(
    of: dataRow,
    matching: find.byWidgetPredicate(
      (widget) => widget is SizedBox && widget.child is Material,
    ),
  ).at(monthIndex);
}

void _useLargeSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(2400, 1600);
  tester.view.devicePixelRatio = 1.0;

  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
