import 'package:contrapp/object/operation.dart';
import 'package:flutter/material.dart';

class Equipment extends Object {
  final String equipName;
  final String information;
  final String emplacement;
  final String type;
  final String marque;
  int number;
  int visitsPerYear;
  int minutesExpected;

  final ValueNotifier<int> priceNotifier = ValueNotifier<int>(0);

  final ValueNotifier<double> hoursExpectedNotifier = ValueNotifier<double>(0);

  List<Operation> operations = [];


  Equipment({ 
    required this.equipName, 
    this.information = '', 
    this.emplacement = '', 
    this.type = '', 
    this.marque = '', 
    this.visitsPerYear = 1, 
    this.minutesExpected = 120, 
    this.number = 1
  });

  Map<String, dynamic> toJson() {
    return {
      'equipName': equipName,
      'information': information,
      'emplacement': emplacement,
      'type': type,
      'marque': marque,
      'visitsPerYear': visitsPerYear,
      'minutesExpected': minutesExpected,
      'operations': operations.map((operation) => operation.toJson()).toList(),
    };
  }

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      equipName: json['equipName'],
      information: json['information'],
      emplacement: json['emplacement'],
      type: json['type'],
      marque: json['marque'],
      visitsPerYear: json['visitsPerYear'],
      minutesExpected: json['minutesExpected'],
    );
  }

  Equipment clone() {
    return Equipment(
      equipName: equipName,
      information: information,
      emplacement: emplacement,
      type: type,
      marque: marque,
      visitsPerYear: visitsPerYear,
      minutesExpected: minutesExpected,
      number: number,
    );
  }

}