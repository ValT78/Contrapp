import 'package:contrapp/object/equipment.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

List<pw.Widget> buildOperation(List<Equipment> equipments, pw.TextStyle style, pw.TextStyle styleBold) {
  return equipments.map((equipment) {
    return pw.Table(
      columnWidths: {
        0: const pw.FixedColumnWidth(200), // Largeur fixe pour la colonne des équipements
        1: const pw.FixedColumnWidth(60), // Largeur fixe pour la colonne des visites
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
              child: pw.Text("visites / an", textAlign: pw.TextAlign.center, style: styleBold.copyWith(color: PdfColors.white)),
            ),
          ],
        ),
        ...equipment.operationsNotifier.value.map((operation) {
          return pw.TableRow(
            children: [
              pw.Container(
                color: PdfColors.blue50,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(operation.operationNameNotifier.value, maxLines: 3, overflow: pw.TextOverflow.clip, style: style),
                ),
              ),
              pw.Container(
                color: PdfColors.blue100,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(operation.visits.toString(), textAlign: pw.TextAlign.center, style: style),
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
