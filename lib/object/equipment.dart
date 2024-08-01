import 'package:contrapp/object/operation.dart';

class Equipment extends Object {
  final String equipName;
  final String information;
  final String emplacement;
  final String type;
  final String marque;
  final int visitsPerYear;
  final double minutesExpected;

  final double price;
  final double daysExpected;

  List<Operation> operations = [];


  Equipment({ required this.equipName, this.information = '', this.emplacement = '', this.type = '', this.marque = '', this.visitsPerYear = 1, this.minutesExpected = 1, this.price = 0, this.daysExpected = 0});
}