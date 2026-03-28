import 'package:contrapp/main.dart' as app;
import 'package:contrapp/specific_tiles/astreinte_button.dart';
import 'package:contrapp/specific_tiles/tva_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    app.resetAppData();
  });

  group('Contract controls', () {
    testWidgets(
      'AstreinteButton toggles the astreinte flag and updates totals when the amount changes',
      (tester) async {
        _useLargeSurface(tester);
        app.customTva = 20;
        app.montantHT = 100;

        await tester.pumpWidget(_buildTestApp(const AstreinteButton()));
        await tester.pump();

        expect(app.variablesContrat['hasAstreinte'], isFalse);
        expect(app.totalHTNotifier.value, 100);
        expect(app.montantTTCNotifier.value, 120);

        await tester.tap(find.textContaining('Astreinte'));
        await tester.pumpAndSettle();

        expect(app.variablesContrat['hasAstreinte'], isTrue);

        await tester.enterText(find.byType(TextFormField), '50');
        await tester.pump();

        expect(app.montantAstreinte, 50);
        expect(app.totalHTNotifier.value, 150);
        expect(app.montantTTCNotifier.value, 180);

        await tester.tap(find.textContaining('Astreinte'));
        await tester.pumpAndSettle();

        expect(app.variablesContrat['hasAstreinte'], isFalse);
        expect(app.montantAstreinte, 0);
        expect(app.totalHTNotifier.value, 100);
        expect(app.montantTTCNotifier.value, 120);
      },
    );

    testWidgets(
      'TvaButton toggles the custom TVA flag and recomputes TTC with the entered rate',
      (tester) async {
        _useLargeSurface(tester);
        app.montantHT = 100;
        app.montantAstreinte = 50;

        await tester.pumpWidget(_buildTestApp(const TvaButton()));
        await tester.pump();

        expect(app.variablesContrat['hasCustomTva'], isFalse);
        expect(app.customTva, 20);
        expect(app.totalHTNotifier.value, 150);
        expect(app.montantTTCNotifier.value, 180);

        await tester.tap(find.textContaining('Modifier'));
        await tester.pumpAndSettle();

        expect(app.variablesContrat['hasCustomTva'], isTrue);

        await tester.enterText(find.byType(TextFormField), '10');
        await tester.pump();

        expect(app.customTva, 10);
        expect(app.montantTTCNotifier.value, 165);

        await tester.tap(find.textContaining('Modifier'));
        await tester.pumpAndSettle();

        expect(app.variablesContrat['hasCustomTva'], isFalse);
        expect(app.customTva, 20);
        expect(app.montantTTCNotifier.value, 180);
      },
    );
  });
}

Widget _buildTestApp(Widget child) {
  return MaterialApp(
    home: MediaQuery(
      data: const MediaQueryData(
        size: Size(2400, 1600),
        textScaler: TextScaler.linear(0.7),
      ),
      child: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: child,
        ),
      ),
    ),
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
