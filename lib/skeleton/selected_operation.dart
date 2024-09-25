import 'package:contrapp/specific_tiles/operation_tile.dart';
import 'package:contrapp/main.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/operation.dart';
import 'package:flutter/material.dart';

class SelectedOperation extends StatelessWidget {
  final ValueNotifier<List<Operation>> operationsNotifier;
  final Equipment equipment;

  const SelectedOperation({super.key, required this.equipment, required this.operationsNotifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: ValueListenableBuilder<List<Operation>>(
        valueListenable: operationsNotifier,
        builder: (context, operations, _) {
          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(120, 0, 0, 8),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Visite / an",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      VerticalDivider(thickness: 2, color: Colors.black, indent: 2, endIndent: 2),
                      Expanded(
                        flex: 4,
                        child: Text(
                          "Désignation",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      VerticalDivider(thickness: 2, color: Colors.black, indent: 2, endIndent: 2),
                      Expanded(
                        child: Text(
                          "Par défaut",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ...operations.map((operation) {
                return OperationTile(
                  operation: operation,
                  onDelete: () {
                    operationsNotifier.value = List.from(operations)..remove(operation);
                  },
                  changedDefaultSelected: (bool selected) {
                    equipToPick.changedDefaultSelected(equipment.equipName, operation, selected);
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
