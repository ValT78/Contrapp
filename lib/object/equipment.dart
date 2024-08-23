import 'package:contrapp/object/machine.dart';
import 'package:contrapp/object/operation.dart';
import 'package:flutter/material.dart';

class Equipment extends Object {

    final String equipName;

    ValueNotifier<List<Operation>> operationsNotifier;

    List<Machine> machines;

    Equipment({
      required this.equipName,
      List<Operation> operations = const [],
      this.machines = const [],
    }): operationsNotifier = ValueNotifier<List<Operation>>(operations);

    // Constructeur nommé pour initialiser avec une machine par défaut
    Equipment.oneValue({
      required this.equipName,
    }) : machines = [Machine()],
         operationsNotifier = ValueNotifier<List<Operation>>([]);

    Map<String, dynamic> toJson() {
      return {
        'equipName': equipName,
        'operations': operationsNotifier.value.map((operation) => operation.toJson()).toList(),
        'machines': machines.map((machine) => machine.toJson()).toList(),
      };
    }

    factory Equipment.fromJson(Map<String, dynamic> json) {
      return Equipment(
        equipName: json['equipName'],
        operations: json['operations'].map<Operation>((operation) => Operation.fromJson(operation)).toList(),
        machines: json['machines'].map<Machine>((machine) => Machine.fromJson(machine)).toList(),
      );
    }

    Equipment clone() {
      
      return Equipment(
        equipName: equipName,
        operations: operationsNotifier.value.where((element) => element.defaultSelected).map((operation) => operation.clone()).toList(),
        machines: machines.map((machine) => machine.clone()).toList(),
      );
    }

    void addMachine(Machine machine) {
      machines.add(machine);
    }

    void addOperation(Operation operation) {
      operationsNotifier.value = List.from(operationsNotifier.value)..add(operation);
    }

    void addOperationName(String operationName) {
      Operation operation = Operation(operationName: operationName);
      operationsNotifier.value = List.from(operationsNotifier.value)..add(operation);
    }

    void removeOperation(Operation operation) {
      operationsNotifier.value = List.from(operationsNotifier.value)..remove(operation);
    }
}