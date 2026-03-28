import 'package:contrapp/object/equipment.dart';

const List<String> calendarMonths = [
  'Jan',
  'Fév',
  'Mar',
  'Avr',
  'Mai',
  'Jui',
  'Jul',
  'Aoû',
  'Sep',
  'Oct',
  'Nov',
  'Déc',
];

// On définit des types customs pour la lisibilité et la maintenabilité du code
typedef MonthSelection = Map<String, bool>; 
typedef OperationCalendar = Map<String, MonthSelection>;
typedef EquipmentCalendarData = Map<String, dynamic>;
typedef SelectedCalendarData = Map<String, EquipmentCalendarData>;

// Constructeur pour créer une sélection de mois vide
MonthSelection createEmptyMonthSelection([
  Iterable<String> months = calendarMonths,
]) {
  return {for (final month in months) month: false};
}

// Fonction pour normaliser les données de sélection de mois, en gérant les différentes structures possibles
MonthSelection _normalizeMonthSelection(
  dynamic rawSelection,
  Iterable<String> months,
) {
  final normalized = createEmptyMonthSelection(months);

  if (rawSelection is Map) {
    for (final month in months) {
      normalized[month] = rawSelection[month] == true;
    }
  }

  return normalized;
}

// Prend en entrée des données brutes de calendrier et les normalise pour garantir une structure cohérente, même si les données d'origine sont incomplètes ou mal formées
// Permet de s'assurer que chaque équipement a une entrée valide dans le calendrier, avec une sélection de mois même si les données d'origine sont absentes ou incorrectes
SelectedCalendarData normalizeSelectedCalendar(
  dynamic rawCalendar,
  List<Equipment> equipments, [
  Iterable<String> months = calendarMonths,
]) {
  final source = rawCalendar is Map ? rawCalendar : const {};
  final normalized = <String, EquipmentCalendarData>{};

  for (final equipment in equipments) {
    final rawEntry = source[equipment.equipName];
    final hasNestedStructure =
        rawEntry is Map &&
        (rawEntry.containsKey('months') || rawEntry.containsKey('operations'));

    final equipmentMonths = _normalizeMonthSelection(
      hasNestedStructure ? rawEntry['months'] : rawEntry,
      months,
    );

    final rawOperations =
        hasNestedStructure && rawEntry['operations'] is Map
            ? rawEntry['operations'] as Map
            : const {};

    final operations = <String, MonthSelection>{};
    for (final operation in equipment.operationsNotifier.value) {
      final operationName = operation.operationNameNotifier.value;
      operations[operationName] = _normalizeMonthSelection(
        rawOperations[operationName],
        months,
      );
    }

    normalized[equipment.equipName] = {
      'months': equipmentMonths,
      'operations': operations,
    };
  }

  return normalized;
}

void syncSelectedCalendarWithEquipments(
  SelectedCalendarData calendar,
  List<Equipment> equipments, [
  Iterable<String> months = calendarMonths,
]) {
  final normalized = normalizeSelectedCalendar(calendar, equipments, months);
  calendar
    ..clear()
    ..addAll(normalized);
}

// Prend en entrée un calendrier et un nom d'équipement, et garantit que cet équipement a une entrée valide dans le calendrier, avec une sélection de mois même si les données d'origine sont absentes ou incorrectes.
// Pour la compatibilité
EquipmentCalendarData _ensureEquipmentEntry(
  SelectedCalendarData calendar,
  String equipName, [
  Iterable<String> months = calendarMonths,
]) {
  final rawEntry = calendar[equipName];
  final rawEntryMap = rawEntry is Map ? rawEntry : null;
  final hasNestedStructure =
      rawEntryMap != null &&
      (rawEntryMap.containsKey('months') ||
          rawEntryMap.containsKey('operations'));

  final normalizedEntry = <String, dynamic>{
    'months': _normalizeMonthSelection(
      hasNestedStructure ? rawEntryMap['months'] : rawEntry,
      months,
    ),
    'operations': <String, MonthSelection>{},
  };

  if (hasNestedStructure && rawEntryMap['operations'] is Map) {
    final rawOperations = rawEntryMap['operations'] as Map;
    normalizedEntry['operations'] = rawOperations.map<String, MonthSelection>(
      (key, value) => MapEntry(
        key.toString(),
        _normalizeMonthSelection(value, months),
      ),
    );
  }

  calendar[equipName] = normalizedEntry;
  return normalizedEntry;
}

MonthSelection getEquipmentMonthSelection(
  SelectedCalendarData calendar,
  String equipName, [
  Iterable<String> months = calendarMonths,
]) {
  final entry = _ensureEquipmentEntry(calendar, equipName, months);
  return entry['months'] as MonthSelection;
}

OperationCalendar getOperationMonthSelections(
  SelectedCalendarData calendar,
  String equipName, [
  Iterable<String> months = calendarMonths,
]) {
  final entry = _ensureEquipmentEntry(calendar, equipName, months);
  final rawOperations = entry['operations'];

  if (rawOperations is OperationCalendar) {
    return rawOperations;
  }

  final normalized = <String, MonthSelection>{};
  if (rawOperations is Map) {
    for (final operationEntry in rawOperations.entries) {
      normalized[operationEntry.key.toString()] = _normalizeMonthSelection(
        operationEntry.value,
        months,
      );
    }
  }
  entry['operations'] = normalized;
  return normalized;
}

// Renvoie la sélection de mois pour une opération spécifique. 
//Renvoie une sélection de mois vide si l'opération n'existe pas encore dans le calendrier
MonthSelection getOperationMonthSelection(
  SelectedCalendarData calendar,
  String equipName,
  String operationName, [
  Iterable<String> months = calendarMonths,
]) {
  final operations = getOperationMonthSelections(calendar, equipName, months);
  return operations.putIfAbsent(
    operationName,
    () => createEmptyMonthSelection(months),
  );
}

bool hasAnySelectedMonth(MonthSelection selection) {
  return selection.values.any((selected) => selected);
}
