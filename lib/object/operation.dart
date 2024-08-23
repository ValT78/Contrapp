import 'package:flutter/widgets.dart';

class Operation extends Object {
  ValueNotifier<String> operationNameNotifier;
  int visits;
  bool defaultSelected;

  Operation(
     {required operationName, this.visits = 1, this.defaultSelected = false}): operationNameNotifier = ValueNotifier<String>(operationName);

  Map<String, dynamic> toJson() {
    return {
      'operationName': operationNameNotifier.value,
      'visits': visits,
      'defaultSelected': defaultSelected,
    };
  }

  factory Operation.fromJson(Map<String, dynamic> json) {
    return Operation(
      operationName: json['operationName'],
      visits: json['visits'],
      defaultSelected: json['defaultSelected'],
    );
  }

  Operation clone() {
    return Operation(
      operationName: operationNameNotifier.value,
      visits: visits,
      defaultSelected: defaultSelected,
    );
  }
}