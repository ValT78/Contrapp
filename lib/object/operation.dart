class Operation extends Object {
  String operationName;
  int visits;
  bool defaultSelected;
  bool isSelected = false;

  Operation(
     {required this.operationName, this.visits = 1, this.defaultSelected = false});

  Map<String, dynamic> toJson() {
    return {
      'operationName': operationName,
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
}