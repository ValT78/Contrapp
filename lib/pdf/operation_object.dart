import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/operation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

List<pw.Widget> buildOperation(List<Equipment> equipments, pw.TextStyle style, pw.TextStyle styleBold) {
  return equipments.map((equipment) {
    if(equipment.operationsNotifier.value.isEmpty) return pw.Container();
    return pw.Table(
      columnWidths: {
        0: const pw.FixedColumnWidth(200), // Largeur fixe pour la colonne des équipements
        1: const pw.FixedColumnWidth(30), // Largeur fixe pour la colonne des visites
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
              child: pw.Text(equipment.equipName, textAlign: pw.TextAlign.center, style: styleBold.copyWith(color: PdfColors.white)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text("visites par an", textAlign: pw.TextAlign.center, style: styleBold.copyWith(color: PdfColors.white)),
            ),
          ],
        ),
        ...buildTableRows(equipment.operationsNotifier.value, style),
      ],
      border: const pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        verticalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5), // Délimitation verticale entre les colonnes
      ),
    );
  }).toList();
}

List<pw.TableRow> buildTableRows(List<Operation> operations, pw.TextStyle style) {
  List<pw.TableRow> rows = [];

  for (var operation in operations) {
    // Calculer la hauteur maximale de la ligne
    double maxHeight = calculateMaxHeight([
      (operation.operationNameNotifier.value),
      '${operation.visits}'
    ], style);

    rows.add(
      pw.TableRow(
        children: [
          buildCell(operation.operationNameNotifier.value, style, maxHeight, PdfColors.blue50),
          buildCell('${operation.visits}', style, maxHeight, PdfColors.blue100),
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
  return 20.0 * ((text.length/70).ceil()); // Exemple de hauteur fixe
}

pw.Widget buildCell(String text, pw.TextStyle style, double height, PdfColor? color) {
  return pw.Container(
    height: height,
    alignment: pw.Alignment.center,
    color: color,
    child: pw.Text(text, style: style, textAlign: pw.TextAlign.center),
  );
}