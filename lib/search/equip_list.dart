import 'package:flutter/material.dart';

class EquipList extends ChangeNotifier {
  final List<String> _equipPickedList = [];

  List<String> get equipPickedList => _equipPickedList;

  void add(String item) {
    _equipPickedList.add(item);
    notifyListeners();
  }
}
