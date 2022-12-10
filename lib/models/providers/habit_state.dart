import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/models/habit.dart';
import 'package:flutter_application_1/models/trackable_item.dart';
import '../../static_data/habits_data.dart';

class HabitState extends ChangeNotifier {
  late String date;
  Map<String, int> habitCountMapping = HashMap();
  Map<String, Habit> habitMap = fetchHabitMap();
  HabitState(DateTime dateTime) {
    this.date = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    List<Habit> habits = fetchHabitsData();
    for (int i = 0; i < habits.length; i++) {
      this.habitMap[habits[i].label] = habits[i];
    }
  }

  updateState(String date, Map<String, int> map) {
    this.date = date;
    habitCountMapping = map;
    print("Current HabitState ${this.habitCountMapping}");
    notifyListeners();
  }

  Map<String, int> toMap() {
    return habitCountMapping;
  }

  String getValue(Map<String,int> habitCountMapping, String key) {
    Habit habit = habitMap[key]!;
    if (!habitCountMapping.containsKey(key)) return "";
    switch (habit.metric) {
      case Metric.unit:
        return (habitCountMapping[key]!).toString();
      case Metric.hrs:
        double timeSpent = habitCountMapping[key]! * habit.multiplier;
        return "${timeSpent} hrs";
      case Metric.ltrs:
        double numLitres = habitCountMapping[key]! * habit.multiplier;
        return "${numLitres} ltrs";
      default:
        return "";
    }
  }
}
