import 'package:contrapp/button/variable_indicator.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/button/custom_form_field.dart';
import 'package:contrapp/object/operation.dart';

class OperationTile extends StatefulWidget {
  final Operation operation;
  final VoidCallback onDelete;

  final Function changedDefaultSelected;

  const OperationTile({super.key, required this.operation, required this.onDelete, required this.changedDefaultSelected});

  @override
  OperationTileState createState() => OperationTileState();
}

class OperationTileState extends State<OperationTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child:
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(800),
              border: Border.all(
                color: Colors.red[900]!,
                width: 2,
              ),
              color: Colors.red[700],
            ),
            child: IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.black,
              onPressed: widget.onDelete,
            ),
          ),
          ),
          const Spacer(flex: 1),
          CustomFormField(
            color: Colors.blue,
            icon: Icons.build_circle,
            textSize: 32,
            onChanged: (value) {
              setState(() {
                widget.operation.visits = value;
              });
            },
            initValue: widget.operation.visits,
            width: 100,
          ),
          const Spacer(flex: 1),
          Flexible(
            fit: FlexFit.loose,
            flex: 12,
            child: VariableIndicator(
              color: Colors.blue,
              icon: Icons.build,
              variableNotifier: widget.operation.operationNameNotifier,
              textSize: 32,
              height: 50,
            ),
          ),
          const Spacer(flex: 1),
          Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepPurple, width: 3),
              color: Colors.purple[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            height: 55,
            width: 55,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    widget.operation.defaultSelected = !widget.operation.defaultSelected;
                    widget.changedDefaultSelected(widget.operation.defaultSelected);
                  });
                },
                child: widget.operation.defaultSelected
                    ? const Center(
                        child: Icon(Icons.check, size: 48, color: Colors.deepPurple))
                    : null,
              ),
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
  