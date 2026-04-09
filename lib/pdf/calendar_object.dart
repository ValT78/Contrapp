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

class _CalendarRowData {
  const _CalendarRowData({
    required this.label,
    required this.monthsSelection,
    required this.style,
    required this.backgroundColor,
    this.leftPadding = 4,
  });

  final String label;
  final MonthSelection monthsSelection;
  final pw.TextStyle style;
  final PdfColor backgroundColor;
  final double leftPadding;

  double get rowHeight =>
      max(15.0 * (label.length / 25).ceil(), 30.0).toDouble();
}

List<pw.Widget> buildCalendar(
  SelectedCalendarData selectedCalendar,
  pw.TextStyle style,
  pw.TextStyle styleBold,
) {
  final rows = <_CalendarRowData>[];

  for (final equip in selectedCalendar.keys) {
    final equipmentMonths = getEquipmentMonthSelection(selectedCalendar, equip);
    final detailedOperations = getOperationMonthSelections(
      selectedCalendar,
      equip,
    ).entries.where((entry) => hasAnySelectedMonth(entry.value));

    rows.add(
      _CalendarRowData(
        label: equip,
        monthsSelection: equipmentMonths,
        style: style.copyWith(fontSize: 7),
        backgroundColor: PdfColors.blue100,
      ),
    );

    for (final operation in detailedOperations) {
      rows.add(
        _CalendarRowData(
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
    _buildCalendarTable(
      rows: rows,
      styleBold: styleBold,
    ),
  ];
}

pw.Widget _buildCalendarTable({
  required List<_CalendarRowData> rows,
  required pw.TextStyle styleBold,
}) {
  return pw.Table(
    columnWidths: {
      0: const pw.FixedColumnWidth(125),
      for (int i = 1; i <= calendarMonths.length; i++)
        i: const pw.FixedColumnWidth(40),
    },
    children: [
      pw.TableRow(
        repeat: true,
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
      ...rows.map(_buildCalendarRow),
    ],
    border: const pw.TableBorder(
      horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
      verticalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
    ),
  );
}

pw.TableRow _buildCalendarRow(_CalendarRowData row) {
  return pw.TableRow(
    children: [
      pw.Container(
        color: row.backgroundColor,
        height: row.rowHeight,
        child: pw.Padding(
          padding: pw.EdgeInsets.fromLTRB(row.leftPadding, 4, 4, 4),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              row.label,
              maxLines: 4,
              overflow: pw.TextOverflow.clip,
              style: row.style,
            ),
          ),
        ),
      ),
      ...calendarMonths.map(
        (month) => pw.Container(
          alignment: pw.Alignment.center,
          height: row.rowHeight,
          color: row.backgroundColor == PdfColors.blue100
              ? PdfColors.blue50
              : null,
          child: pw.Center(
            child: row.monthsSelection[month] == true
                ? buildCheckmark()
                : pw.Container(),
          ),
        ),
      ),
    ],
  );
}
