import 'package:contrapp/button/operation_tile.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/operation.dart';
import 'package:flutter/material.dart';

//Les équipements sélectionnés dans la page des équipements
class SelectedOperation extends StatefulWidget {
  final ValueNotifier<List<Operation>> operationsNotifier;
  final Equipment equipment;
  const SelectedOperation({super.key, required this.equipment, required this.operationsNotifier});

  @override
  SelectedOperationState createState() => SelectedOperationState();
}

class SelectedOperationState extends State<SelectedOperation> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8.0),
        // border: Border.all(color: Colors.black), // Ajout de la bordure noire
      ),
      padding: const EdgeInsets.all(16.0),
      child: ValueListenableBuilder<List<Operation>>(
      valueListenable: widget.operationsNotifier,
      builder: (context, operations, _) {
        return ListView(
          children: operations.map((operation) {
            return OperationTile(
              operation: operation,
              onDelete: () {
                widget.operationsNotifier.value = List.from(operations)..remove(operation);
              },
            );
          }).toList(),
        );
      },
      )
    );
    }
  }