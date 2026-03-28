import 'package:contrapp/object/contract_calendar.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  final List<Equipment> equipments;
  final List<String> months;
  final SelectedCalendarData selectedCalendar;
  final Set<String> expandedEquipments;
  final Function(String, String) onEquipmentMonthTap;
  final Function(String, String, String) onOperationMonthTap;
  final Function(String) onToggleExpanded;

  const Calendar({
    super.key,
    required this.equipments,
    required this.months,
    required this.selectedCalendar,
    required this.expandedEquipments,
    required this.onEquipmentMonthTap,
    required this.onOperationMonthTap,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final unitWidth = totalWidth / (months.length + 6);
        final labelWidth = unitWidth * 5;
        final monthWidth = unitWidth;
        final totalColumnWidth = unitWidth;
        final rowHeight = unitWidth / 1.5;
        final titleFontSize = 30 * totalWidth / 1920;
        final labelFontSize = 24 * totalWidth / 1920;
        final totalFontSize = 32 * totalWidth / 1920;

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeaderRow(
                labelWidth: labelWidth,
                monthWidth: monthWidth,
                totalColumnWidth: totalColumnWidth,
                rowHeight: rowHeight,
                titleFontSize: titleFontSize,
              ),
              ...equipments.expand((equipment) {
                final equipName = equipment.equipName;
                final operations = equipment.operationsNotifier.value;
                final rows = <Widget>[
                  _buildDataRow(
                    label: equipName,
                    selectedMonths: getEquipmentMonthSelection(
                      selectedCalendar,
                      equipName,
                      months,
                    ),
                    onMonthTap: (month) => onEquipmentMonthTap(equipName, month),
                    labelWidth: labelWidth,
                    monthWidth: monthWidth,
                    totalColumnWidth: totalColumnWidth,
                    rowHeight: rowHeight,
                    labelFontSize: labelFontSize,
                    totalFontSize: totalFontSize,
                    backgroundColor: Colors.blue[100]!,
                    showExpandButton: operations.isNotEmpty,
                    isExpanded: expandedEquipments.contains(equipName),
                    onToggleExpanded: () => onToggleExpanded(equipName),
                  ),
                ];

                if (expandedEquipments.contains(equipName)) {
                  for (final operation in operations) {
                    final operationName = operation.operationNameNotifier.value;
                    rows.add(
                      _buildDataRow(
                        label: operationName,
                        selectedMonths: getOperationMonthSelection(
                          selectedCalendar,
                          equipName,
                          operationName,
                          months,
                        ),
                        onMonthTap: (month) => onOperationMonthTap(
                          equipName,
                          operationName,
                          month,
                        ),
                        labelWidth: labelWidth,
                        monthWidth: monthWidth,
                        totalColumnWidth: totalColumnWidth,
                        rowHeight: rowHeight,
                        labelFontSize: labelFontSize * 0.9,
                        totalFontSize: totalFontSize * 0.9,
                        backgroundColor: Colors.blue[50]!,
                        showExpandButton: false,
                        isOperation: true,
                      ),
                    );
                  }
                }

                return rows;
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderRow({
    required double labelWidth,
    required double monthWidth,
    required double totalColumnWidth,
    required double rowHeight,
    required double titleFontSize,
  }) {
    return Row(
      children: [
        _buildHeaderCell(
          label: 'Equipement',
          width: labelWidth,
          height: rowHeight,
          fontSize: titleFontSize,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
          ),
        ),
        ...months.map(
          (month) => _buildHeaderCell(
            label: month,
            width: monthWidth,
            height: rowHeight,
            fontSize: titleFontSize,
          ),
        ),
        _buildHeaderCell(
          label: 'Total',
          width: totalColumnWidth,
          height: rowHeight,
          fontSize: titleFontSize,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(5),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell({
    required String label,
    required double width,
    required double height,
    required double fontSize,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.blue[900],
        border: Border(
          right: BorderSide(color: Colors.grey[300]!),
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow({
    required String label,
    required MonthSelection selectedMonths,
    required ValueChanged<String> onMonthTap,
    required double labelWidth,
    required double monthWidth,
    required double totalColumnWidth,
    required double rowHeight,
    required double labelFontSize,
    required double totalFontSize,
    required Color backgroundColor,
    required bool showExpandButton,
    bool isExpanded = false,
    bool isOperation = false,
    VoidCallback? onToggleExpanded,
  }) {
    final total = selectedMonths.values.where((selected) => selected).length;

    return Row(
      children: [
        Container(
          width: labelWidth,
          height: rowHeight,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              right: BorderSide(color: Colors.grey[300]!),
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Row(
            children: [
              if (showExpandButton)
                IconButton(
                  onPressed: onToggleExpanded,
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.blue[900],
                    size: labelFontSize * 1.2,
                  ),
                )
              else if (isOperation)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.subdirectory_arrow_right,
                    color: Colors.blue[900],
                    size: labelFontSize,
                  ),
                )
              else
                const SizedBox(width: 48),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isOperation ? FontWeight.w500 : FontWeight.w700,
                    fontSize: labelFontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...months.map(
          (month) => _buildMonthCell(
            selected: selectedMonths[month] ?? false,
            width: monthWidth,
            height: rowHeight,
            onTap: () => onMonthTap(month),
          ),
        ),
        Container(
          width: totalColumnWidth,
          height: rowHeight,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              right: BorderSide(color: Colors.grey[300]!),
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Center(
            child: Text(
              '$total',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: totalFontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthCell({
    required bool selected,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey[300]!),
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  margin: EdgeInsets.all(width * 0.12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? Colors.blue[800] : Colors.transparent,
                  ),
                  child: selected
                      ? const Center(
                          child: Text(
                            '✓',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
