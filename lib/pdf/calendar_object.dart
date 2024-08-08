import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

List<String> months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jui', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];

pw.Widget buildCheckmark() {
  return pw.Container(
    width: 20,
    height: 20,
    decoration: const pw.BoxDecoration(
      color: PdfColors.blue300,
      shape: pw.BoxShape.circle,
    ),
    child: pw.Center(
      child: pw.Text(
        'X',
        style: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ),
  );
}

List<pw.Widget> buildCalendar(Map<String, Map<String, bool>> selectedCalendar) {
  return [
    pw.Wrap(
      children: [
        pw.Table(
          columnWidths: {
            0: const pw.FixedColumnWidth(135), // Largeur fixe pour la colonne des équipements
            for (int i = 1; i <= months.length; i++) i: const pw.FixedColumnWidth(40), // Largeur fixe pour les colonnes des mois
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.blue200), // Fond légèrement grisé pour les labels des mois
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text("EQUIPEMENT", textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                ...months.map((month) => pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(month, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                )),
              ],
            ),
            for (var equip in selectedCalendar.keys)
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(equip, maxLines: 3, overflow: pw.TextOverflow.clip),
                  ),
                  ...months.map((month) => pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Center(child: selectedCalendar[equip]?[month] == true ? buildCheckmark() : pw.Container()), // Centrage vertical du widget checkMark
                  )),
                ],
              ),
          ],
          border: const pw.TableBorder(
            horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            verticalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5), // Délimitation verticale entre les colonnes
          ),
        ),
      ],
    ),
  ];
}
