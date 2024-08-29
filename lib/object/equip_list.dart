import 'package:contrapp/main.dart' show modifyApp;
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/machine.dart';
import 'package:contrapp/object/operation.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier, ValueNotifier;

class EquipList extends ChangeNotifier {
  final List<Equipment> _equipList = [];
  final bool isModifyingApp;

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

  void changedDefaultSelected(String equipName, Operation operation, bool selected) {
    _equipList.firstWhere((element) => element.equipName == equipName).operationsNotifier.value.firstWhere((element) => element.operationNameNotifier.value == operation.operationNameNotifier.value).defaultSelected = selected;
    notifyListeners();
    if (isModifyingApp) {
      modifyApp();
    }
  }

  
}

