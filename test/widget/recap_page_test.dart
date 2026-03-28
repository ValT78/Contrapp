import 'package:contrapp/common_tiles/number_indicator.dart';
import 'package:contrapp/main.dart' as app;
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/machine.dart';
import 'package:contrapp/object/operation.dart';
import 'package:contrapp/pages/recap_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    app.resetAppData();
    app.equipPicked.equipList = [];
    app.attachList = [];
  });

  testWidgets(
    'RecapPage shows contract counters and the values coming from global notifiers',
    (tester) async {
      _useLargeSurface(tester);
      app.variablesContrat['entreprise'] = 'Client Test';
      app.attachList = ['piece-1', 'piece-2'];
      app.equipPicked.equipList = [
        Equipment(
          equipName: 'Centrale',
          operations: [
            Operation(operationName: 'Entretien'),
            Operation(operationName: 'Controle'),
          ],
          machines: [
            Machine(),
            Machine(),
          ],
        ),
        Equipment(
          equipName: 'Vitrine',
          operations: [
            Operation(operationName: 'Degivrage'),
          ],
          machines: [
            Machine(),
          ],
        ),
      ];
      app.hoursOfWorkNotifier.value = 6.0;
      app.montantHTNotifier.value = 600;
      app.totalHTNotifier.value = 650;
      app.montantTTCNotifier.value = 780;

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [app.routeObserver],
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(2400, 1600),
              textScaler: TextScaler.linear(0.5),
            ),
            child: const RecapPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Client Test'), findsOneWidget);

      final indicators = tester.widgetList<NumberIndicator>(
        find.byType(NumberIndicator),
      ).toList();

      expect(indicators.map((indicator) => indicator.text), [
        'Équipements',
        'Opérations',
        'Pièces-Jointes',
      ]);
      expect(indicators.map((indicator) => indicator.number), [3, 3, 2]);

      expect(find.text('6.0'), findsOneWidget);
      expect(find.text('600'), findsOneWidget);
      expect(find.text('650'), findsOneWidget);
      expect(find.text('780'), findsOneWidget);
    },
  );
}

void _useLargeSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(2400, 1600);
  tester.view.devicePixelRatio = 1.0;

  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}


