import 'package:flutter/material.dart';
import 'package:contrapp/button/custom_form_field.dart';
import 'package:contrapp/object/operation.dart';

class OperationTile extends StatelessWidget {
  final Operation operation;
  final VoidCallback onDelete;

  const OperationTile({super.key, required this.operation, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
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
              onPressed: onDelete,
            ),
          ),
          const Spacer(flex: 1),
          CustomFormField(
            color: Colors.blue,
            icon: Icons.build_circle,
            textSize: 32,
            onChanged: (value) {
              operation.visits = value;
            },
            initValue: operation.visits,
            width: 100,
          ),
          const Spacer(flex: 1),
          Flexible(
            fit: FlexFit.loose,
            flex: 12,
            child: CustomFormField(
              color: Colors.blue,
              icon: Icons.build,
              textSize: 32,
              onChanged: (value) {
                operation.operationName = value;
              },
              initValue: operation.operationName,
            ),
          ),
          const Spacer(flex: 1),
          Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple, width: 3),
              color: Colors.purple[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            height: 50,
            width: 50,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  print(operation.defaultSelected);
                  operation.defaultSelected = !operation.defaultSelected;
                },
                child: operation.defaultSelected
                    ? const Center(
                        child: Icon(Icons.check_circle, size: 48, color: Colors.green))
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
