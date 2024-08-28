import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

List<String> months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jui', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];

pw.Widget buildCheckmark() {
  return pw.Container(
    width: 17,
    height: 17,
    decoration: const pw.BoxDecoration(
      color: PdfColors.blue800,
      shape: pw.BoxShape.circle,
    ),
    child: pw.Center(
      child: pw.Text(
        'X',
        style: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
          fontSize: 8,
        ),
      ),
    ),
  );
}

List<pw.Widget> buildCalendar(Map<String, Map<String, bool>> selectedCalendar, pw.TextStyle style, pw.TextStyle styleBold) {
  return [
    pw.Wrap(
      children: [
        pw.Table(
          columnWidths: {
            0: const pw.FixedColumnWidth(125), // Largeur fixe pour la colonne des équipements
            for (int i = 1; i <= months.length; i++) i: const pw.FixedColumnWidth(40), // Largeur fixe pour les colonnes des mois
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
                  child: pw.Text("EQUIPEMENT", textAlign: pw.TextAlign.center, style: styleBold.copyWith(color: PdfColors.white)),
                ),
                ...months.map((month) => pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(month, textAlign: pw.TextAlign.center, style: styleBold.copyWith(color: PdfColors.white)),
                )),
              ],
            ),
            for (var equip in selectedCalendar.keys)
              pw.TableRow(
                children: [
                  pw.Container(
                    color: PdfColors.blue100,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(equip, maxLines: 4, overflow: pw.TextOverflow.clip, style: style.copyWith(fontSize: 7)),
                    ),
                  ),
                  ...months.map((month) => pw.Container(
                    alignment: pw.Alignment.center,
                    height: 15.0*(equip.length/25).ceil(),
                    child: pw.Center(child: 
                    selectedCalendar[equip]?[month] == true ? buildCheckmark() : pw.Container(), // Centrage vertical du widget checkMark
                  
                    ),
                  ),
                  ),
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
