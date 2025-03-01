import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/machine.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

List<pw.Widget> buildEquipment(List<Equipment> equipments, pw.TextStyle style, pw.TextStyle styleBold) {
  double pageHeight = 720; // Hauteur approximative disponible sur une page A4
  double rowHeight = 35; // Hauteur moyenne d'une ligne
  List<pw.Widget> widgets = [];

  double actualHeight = 60; // Hauteur actuelle de la page (il y a un titre au début)

  for (var equipment in equipments) {

    //On a un tableau avec une certaines longueurs totales
    (List<pw.TableRow>, List<double>) allRows = buildTableRows(equipment.machines, style);    
    int j = 0; // Nombre de lignes de ce tableau

    while(j<allRows.$1.length) {
      
      //On vérifie si un header + une ligne peuvent tenir sur la page actuelle
      if(actualHeight + 3*rowHeight > pageHeight) {
        //Si non, on reset pour apsser à la page suivante
        actualHeight = 0;
      }

      int k = 0;
      //Si oui, on ajoute le header + les lignes jusqu'à atteindre la bas de la page
      actualHeight += 2*rowHeight; // On ajoute la hauteur du header
      while(actualHeight<pageHeight && j+k<allRows.$1.length) {
        actualHeight +=allRows.$2[k].toInt();
        k++;
      }

      //Tant qu'on a pas fini le tableau, à chaque fois qu'on atteint le bas de la apge, on génère un nouveau wifget
      List<pw.TableRow> pageRows = allRows.$1.sublist(j, (j + k).clamp(0, allRows.$1.length));

      widgets.add(
        pw.Table(
          columnWidths: {
            0: const pw.FixedColumnWidth(50),
            1: const pw.FixedColumnWidth(280),
            2: const pw.FixedColumnWidth(40),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(
                color: PdfColors.blue900,
                borderRadius: pw.BorderRadius.only(
                  topLeft: pw.Radius.circular(5),
                  topRight: pw.Radius.circular(5),
                ),
              ),
              children: [
                pw.Container(
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.all(4),
                  height: 35,
                  child: pw.Text("Nombre", textAlign: pw.TextAlign.center, style: styleBold.copyWith(color: PdfColors.white)),
                ),
                pw.Container(
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.all(4),
                  height: 35,
                  child: pw.Text(equipment.equipName, textAlign: pw.TextAlign.center, style: styleBold.copyWith(color: PdfColors.white)),
                ),
                pw.Container(
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text("visites par an", textAlign: pw.TextAlign.center, style: styleBold.copyWith(color: PdfColors.white)),
                ),
              ],
            ),
            ...pageRows,
          ],
          border: const pw.TableBorder(
            horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            verticalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
          ),
        ),
      );
      j+=k;
    }
  }

  return widgets;
}


(List<pw.TableRow>, List<double>) buildTableRows(List<Machine> machines, pw.TextStyle style) {
  List<pw.TableRow> rows = [];
  List<double> heights = [];

  for (var machine in machines) {
    // Calculer la hauteur maximale de la ligne
    double maxHeight = calculateMaxHeight([
      '${machine.number}',
      (machine.information.value),
      '${machine.visitsPerYear}'
    ], style);
    heights.add(maxHeight);

    rows.add(
      pw.TableRow(
        children: [
          buildCell('${machine.number}', style, maxHeight, PdfColors.blue100),
          buildCell(machine.information.value, style, maxHeight, PdfColors.blue50),
          buildCell('${machine.visitsPerYear}', style, maxHeight, PdfColors.blue100),
        ],
      ),
    );
  }

  return (rows, heights);
}

double calculateMaxHeight(List<String> texts, pw.TextStyle style) {
  double maxHeight = 0;
  for (var text in texts) {
    double height = measureTextLength(text, style);
    if (height > maxHeight) {
      maxHeight = height;
    }
  }
  return maxHeight;
}

double measureTextLength(String text, pw.TextStyle style) {
  return 20.0 * ((text.length/55).ceil());
}

pw.Widget buildCell(String text, pw.TextStyle style, double height, PdfColor? color) {
  return pw.Container(
    height: height,
    alignment: pw.Alignment.center,
    color: color,
    child: pw.Text(text, style: style, textAlign: pw.TextAlign.center),
  );
}