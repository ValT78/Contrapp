import 'package:contrapp/object/equipment.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

List<pw.Widget> buildOperation(List<Equipment> equipments) {
  return equipments.map((equipment) {
    return pw.Table(
      columnWidths: {
        0: const pw.FixedColumnWidth(200), // Largeur fixe pour la colonne des équipements
        1: const pw.FixedColumnWidth(50), // Largeur fixe pour la colonne des visites
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue200), // Fond légèrement grisé pour les labels des colonnes
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(equipment.equipName, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text("visites / an", textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
        ...equipment.operationsNotifier.value.map((operation) {
          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(operation.operationNameNotifier.value, maxLines: 3, overflow: pw.TextOverflow.clip),
              ),
              pw.Container(
                color: PdfColors.blue50,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(operation.visits.toString(), textAlign: pw.TextAlign.center),
                ),
              ),
            ],
          );
        }),
      ],
      border: const pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        verticalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5), // Délimitation verticale entre les colonnes
      ),
    );
  }).toList();
}
