import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/machine.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

List<pw.Widget> buildEquipment(List<Equipment> equipments, pw.TextStyle style, pw.TextStyle styleBold) {
  return equipments.map((equipment) {
    return pw.Table(
      columnWidths: {
        0: const pw.FixedColumnWidth(50), // Largeur fixe pour la colonne des visites
        1: const pw.FixedColumnWidth(280), // Largeur fixe pour la colonne des équipements
        2: const pw.FixedColumnWidth(40), // Largeur fixe pour la colonne des visites
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(
            color: PdfColors.blue900, // Fond bleu foncé pour les labels des colonnes
            borderRadius: pw.BorderRadius.only(
              topLeft: pw.Radius.circular(5),
              topRight: pw.Radius.circular(5),
            ),
          ),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text("Nombre", textAlign: pw.TextAlign.center, style: styleBold.copyWith(color: PdfColors.white), textScaleFactor: 1.0),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(equipment.equipName, textAlign: pw.TextAlign.center, style: styleBold.copyWith(color: PdfColors.white), textScaleFactor: 1.0),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text("visites par an", textAlign: pw.TextAlign.center, style: styleBold.copyWith(color: PdfColors.white), textScaleFactor: 1.0),
            ),
          ],
        ),
        ...buildTableRows(equipment.machines, style),
      ],
      border: const pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        verticalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5), // Délimitation verticale entre les colonnes
      ),
    );
  }).toList();
}

List<pw.TableRow> buildTableRows(List<Machine> machines, pw.TextStyle style) {
  List<pw.TableRow> rows = [];

  for (var machine in machines) {
    // Calculer la hauteur maximale de la ligne
    double maxHeight = calculateMaxHeight([
      '${machine.number}',
      '${machine.marque.value} - ${machine.information.value}',
      '${machine.visitsPerYear}'
    ], style);

    rows.add(
      pw.TableRow(
        children: [
          buildCell('${machine.number}', style, maxHeight, PdfColors.blue100),
          buildCell('${machine.marque.value} - ${machine.information.value}', style, maxHeight, PdfColors.blue50),
          buildCell('${machine.visitsPerYear}', style, maxHeight, PdfColors.blue100),
        ],
      ),
    );
  }

  return rows;
}

double calculateMaxHeight(List<String> texts, pw.TextStyle style) {
  double maxHeight = 0;
  for (var text in texts) {
    double height = measureTextHeight(text, style);
    if (height > maxHeight) {
      maxHeight = height;
    }
  }
  return maxHeight;
}

double measureTextHeight(String text, pw.TextStyle style) {
  // Implémentez une méthode pour mesurer la hauteur du texte
  // Cela peut nécessiter des calculs personnalisés ou l'utilisation d'une bibliothèque tierce
  return 20.0 * ((text.length/50).ceil()); // Exemple de hauteur fixe
}

pw.Widget buildCell(String text, pw.TextStyle style, double height, PdfColor? color) {
  return pw.Container(
    height: height,
    alignment: pw.Alignment.center,
    color: color,
    child: pw.Text(text, style: style, textAlign: pw.TextAlign.center),
  );
}