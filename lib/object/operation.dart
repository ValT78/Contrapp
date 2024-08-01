class Operation extends Object {
  final String operationName;
  final int visits;
  final bool defaultSelected;

  Operation(this.operationName, {this.visits = 1, this.defaultSelected = false});
}