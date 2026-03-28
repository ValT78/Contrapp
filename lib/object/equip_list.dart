import 'package:contrapp/main.dart' show modifyApp;
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/machine.dart';
import 'package:contrapp/object/operation.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier, ValueNotifier;

class EquipList extends ChangeNotifier {
  final List<Equipment> _equipList = [];
  final bool isModifyingApp; // Liste chargé depuis le .contrapp, et qui le modifie à chaque changement dans cette liste via la fonction modifyApp()

  EquipList({this.isModifyingApp = false});

  List<Equipment> get equipList => _equipList;

  set equipList(List<Equipment> equipList) {
    _equipList.clear();
    _equipList.addAll(equipList);
    notifyListeners();
  }

  void addEquipment(Equipment equip) {
    _equipList.add(equip);
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  void removeEquipmentName(String equipName) {
    _equipList.removeWhere((element) => element.equipName == equipName);
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  void removeEquipment(Equipment equip) {
    _equipList.remove(equip);
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  void removeMachineName(String equipName) {
    _equipList.firstWhere((element) => element.equipName == equipName).machines.removeLast();
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  void addMachine(Equipment equip, Machine machine) {
    equip.addMachine(machine);
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  void addMachineName(Equipment equip, String machineName) {
    equip.addMachine(Machine(marque: machineName));
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  void removeMachine(Equipment equip, Machine machine) {
    equip.machines.remove(machine);
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  ValueNotifier<List<Operation>> getOperations(String equipName) {
    return _equipList.firstWhere((element) => element.equipName == equipName).operationsNotifier;
  }

  void addOperation(String equipName, Operation operation) {
    _equipList.firstWhere((element) => element.equipName == equipName).addOperation(operation);
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  void addOperationName(String equipName, String operationName) {
    _equipList.firstWhere((element) => element.equipName == equipName).addOperationName(operationName);
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  void removeOperation(String equipName, Operation operation) {
    _equipList.firstWhere((element) => element.equipName == equipName).removeOperation(operation);
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
      
  }

  void changedDefaultSelected(
    String equipName,
    Operation operation,
    bool selected,
    List<Operation> orderedOperations,
  ) {
    final equipment =
        _equipList.firstWhere((element) => element.equipName == equipName);
    final sourceIndexes = <String, int>{
      for (int i = 0; i < orderedOperations.length; i++)
        orderedOperations[i].operationNameNotifier.value: i,
    };

    final reorderedOperations = List<Operation>.from(equipment.operationsNotifier.value)
      ..sort((a, b) {
        final aIndex = sourceIndexes[a.operationNameNotifier.value];
        final bIndex = sourceIndexes[b.operationNameNotifier.value];

        if (aIndex != null && bIndex != null) {
          return aIndex.compareTo(bIndex);
        }
        if (aIndex != null) {
          return -1;
        }
        if (bIndex != null) {
          return 1;
        }
        return 0;
      });

    reorderedOperations
        .firstWhere((element) =>
            element.operationNameNotifier.value ==
            operation.operationNameNotifier.value)
        .defaultSelected = selected;
    equipment.operationsNotifier.value = reorderedOperations;
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  void moveOperationUp(String equipName, Operation operation) {
    final equipment =
        _equipList.firstWhere((element) => element.equipName == equipName);
    final operations = List<Operation>.from(equipment.operationsNotifier.value);
    final index = operations.indexOf(operation);
    if (index <= 0) {
      return;
    }

    final previousOperation = operations[index - 1];
    operations[index - 1] = operation;
    operations[index] = previousOperation;
    equipment.operationsNotifier.value = operations;
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  void moveOperationDown(String equipName, Operation operation) {
    final equipment =
        _equipList.firstWhere((element) => element.equipName == equipName);
    final operations = List<Operation>.from(equipment.operationsNotifier.value);
    final index = operations.indexOf(operation);
    if (index == -1 || index >= operations.length - 1) {
      return;
    }

    final nextOperation = operations[index + 1];
    operations[index + 1] = operation;
    operations[index] = nextOperation;
    equipment.operationsNotifier.value = operations;
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  void moveEquipmentUp(Equipment equip) {
    final index = _equipList.indexOf(equip);
    if (index <= 0) {
      return;
    }

    final previousEquipment = _equipList[index - 1];
    _equipList[index - 1] = equip;
    _equipList[index] = previousEquipment;
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  void moveEquipmentDown(Equipment equip) {
    final index = _equipList.indexOf(equip);
    if (index == -1 || index >= _equipList.length - 1) {
      return;
    }

    final nextEquipment = _equipList[index + 1];
    _equipList[index + 1] = equip;
    _equipList[index] = nextEquipment;
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  void moveMachineUp(Equipment equip, Machine machine) {
    final index = equip.machines.indexOf(machine);
    if (index <= 0) {
      return;
    }

    final previousMachine = equip.machines[index - 1];
    equip.machines[index - 1] = machine;
    equip.machines[index] = previousMachine;
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  void moveMachineDown(Equipment equip, Machine machine) {
    final index = equip.machines.indexOf(machine);
    if (index == -1 || index >= equip.machines.length - 1) {
      return;
    }

    final nextMachine = equip.machines[index + 1];
    equip.machines[index + 1] = machine;
    equip.machines[index] = nextMachine;
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  
}

