import 'dart:math';

import 'package:contrapp/object/contract_calendar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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

List<pw.Widget> buildCalendar(
  SelectedCalendarData selectedCalendar,
  pw.TextStyle style,
  pw.TextStyle styleBold,
) {
  final rows = <pw.TableRow>[];

  for (final equip in selectedCalendar.keys) {
    final equipmentMonths = getEquipmentMonthSelection(selectedCalendar, equip);
    final detailedOperations = getOperationMonthSelections(
      selectedCalendar,
      equip,
    ).entries.where((entry) => hasAnySelectedMonth(entry.value));

    rows.add(
      _buildCalendarRow(
        label: equip,
        monthsSelection: equipmentMonths,
        style: style.copyWith(fontSize: 7),
        backgroundColor: PdfColors.blue100,
      ),
    );

    for (final operation in detailedOperations) {
      rows.add(
        _buildCalendarRow(
          label: operation.key,
          monthsSelection: operation.value,
          style: style.copyWith(fontSize: 6.5),
          backgroundColor: PdfColors.blue50,
          leftPadding: 16,
        ),
      );
    }
  }

  return [
    pw.Wrap(
      children: [
        pw.Table(
          columnWidths: {
            0: const pw.FixedColumnWidth(125),
            for (int i = 1; i <= calendarMonths.length; i++)
              i: const pw.FixedColumnWidth(40),
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
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    'EQUIPEMENT',
                    textAlign: pw.TextAlign.center,
                    style: styleBold.copyWith(color: PdfColors.white),
                  ),
                ),
                ...calendarMonths.map(
                  (month) => pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(
                      month,
                      textAlign: pw.TextAlign.center,
                      style: styleBold.copyWith(color: PdfColors.white),
                    ),
                  ),
                ),
              ],
            ),
            ...rows,
          ],
          border: const pw.TableBorder(
            horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            verticalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
          ),
        ),
      ],
    ),
  ];
}

pw.TableRow _buildCalendarRow({
  required String label,
  required MonthSelection monthsSelection,
  required pw.TextStyle style,
  required PdfColor backgroundColor,
  double leftPadding = 4,
}) {
  final rowHeight = max(15.0 * (label.length / 25).ceil(), 30.0).toDouble();

  return pw.TableRow(
    children: [
      pw.Container(
        color: backgroundColor,
        height: rowHeight,
        child: pw.Padding(
          padding: pw.EdgeInsets.fromLTRB(leftPadding, 4, 4, 4),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              label,
              maxLines: 4,
              overflow: pw.TextOverflow.clip,
              style: style,
            ),
          ),
        ),
      ),
      ...calendarMonths.map(
        (month) => pw.Container(
          alignment: pw.Alignment.center,
          height: rowHeight,
          color: backgroundColor == PdfColors.blue50 ? PdfColors.blue50 : null,
          child: pw.Center(
            child: monthsSelection[month] == true
                ? buildCheckmark()
                : pw.Container(),
          ),
        ),
      ),
    ],
  );
}
