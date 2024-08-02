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


  Equipment({ 
    required this.equipName, 
    this.information = '', 
    this.emplacement = '', 
    this.type = '', 
    this.marque = '', 
    this.visitsPerYear = 1, 
    this.minutesExpected = 1, 
    this.price = 0, 
    this.daysExpected = 0
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
      'price': price,
      'daysExpected': daysExpected,
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
      price: json['price'],
      daysExpected: json['daysExpected'],
    );
  }

}