class Operation extends Object {
  final String operationName;
  final int visits;
  final bool defaultSelected;

  Operation(this.operationName, {this.visits = 1, this.defaultSelected = false});

  Map<String, dynamic> toJson() {
    return {
      'operationName': operationName,
      'visits': visits,
      'defaultSelected': defaultSelected,
    };
  }

  factory Operation.fromJson(Map<String, dynamic> json) {
    return Operation(
      json['operationName'],
      visits: json['visits'],
      defaultSelected: json['defaultSelected'],
    );
  }
}