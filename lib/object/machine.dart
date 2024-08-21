import 'package:flutter/material.dart';

class Machine extends Object {
  ValueNotifier<String> information;
  ValueNotifier<String> marque;
  int number;
  int visitsPerYear;
  int minutesExpected;

  final ValueNotifier<int> priceNotifier = ValueNotifier<int>(0);

  final ValueNotifier<double> hoursExpectedNotifier = ValueNotifier<double>(0);

  Machine({ 
    String information = "",
    String marque = "",
    this.visitsPerYear = 1, 
    this.minutesExpected = 0, 
    this.number = 1,
  }): 
          marque = ValueNotifier<String>(marque),

  information = ValueNotifier<String>(information);


  Map<String, dynamic> toJson() {
    return {
      'information': information.value,
      'marque': marque.value,
      'visitsPerYear': visitsPerYear,
      'minutesExpected': minutesExpected,
      'number': number,
    };
  }

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      information: json['information'],
      marque: json['marque'],
      visitsPerYear: json['visitsPerYear'],
      minutesExpected: json['minutesExpected'],
      number: json['number'],
    );
  }

  Machine clone() {
    return Machine(
      information: information.value,
      marque: marque.value,
      visitsPerYear: visitsPerYear,
      minutesExpected: minutesExpected,
      number: number,
    );
  }

}