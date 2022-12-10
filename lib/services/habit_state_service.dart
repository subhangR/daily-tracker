import 'package:flutter_application_1/repositories/habit_state_repository.dart';
import 'dart:collection';
import '../models/habit.dart';
import '../static_data/habits_data.dart';
import '../models/habit_state_dao.dart';
import 'package:get_it/get_it.dart';
import '../util/date_util.dart';

class HabitStateService {
  late Map<String, Habit> habitMap;
  late HabitStateRepository _habitStateRepository;
  HabitStateService() {
    this.habitMap = fetchHabitMap();
    this._habitStateRepository = GetIt.I.get();
  }

  Future<HabitStateDao?> fetchHabitStateDao(String date) async {
    HabitStateDao? habitStateDao =
        await _habitStateRepository.fetchHabitState(date);
    return habitStateDao;
  }

  Future<HabitStateDao> incrementHabit(
      String label, HabitStateDao? habitStateDao) async {
    String currentDate = DateUtil.getDateString(DateTime.now());

    habitStateDao ??= HabitStateDao(currentDate, HashMap());
    habitStateDao.debug("in Increment Habit");
    Map<String, int> updatedHabitCountMap =
        incrementMap(label, habitStateDao.habitCountMap);
    HabitStateDao updatedHabitStateDao =
        HabitStateDao(currentDate, updatedHabitCountMap);
    await _habitStateRepository.updateHabitState(updatedHabitStateDao);
    return habitStateDao;
  }

  Future<HabitStateDao> decrementHabit(
      String label, HabitStateDao? habitStateDao) async {
    String currentDate = DateUtil.getDateString(DateTime.now());
    habitStateDao ??= HabitStateDao(currentDate, HashMap());
    Map<String, int> updatedHabitCountMap =
        decrementMap(label, habitStateDao.habitCountMap);
    HabitStateDao updatedHabitStateDao =
        HabitStateDao(currentDate, updatedHabitCountMap);
    await _habitStateRepository.updateHabitState(updatedHabitStateDao);
    return habitStateDao;
  }

  Map<String, int> incrementMap(
      String key, Map<String, int> habitCountMapping) {
    if (!validateIncrement(habitMap, habitCountMapping, key)) {
      return habitCountMapping;
    }
    print("Before Increment ${habitCountMapping}");
    habitCountMapping.update(
      key,
      (value) => ++value,
      ifAbsent: () => 1,
    );
    print("After Increment ${habitCountMapping}");
    return habitCountMapping;
  }

  Map<String, int> decrementMap(
    String key,
    Map<String, int> habitCountMapping,
  ) {
    if (!validateDecrement(habitMap, habitCountMapping, key)) {
      return habitCountMapping;
    }
    habitCountMapping.update(
      key,
      (value) => --value,
      ifAbsent: () => 1,
    );
    return habitCountMapping;
  }

  bool validateIncrement(
      Map<String, Habit> habitMap, Map<String, int> habitCountMap, String key) {
    if (!habitMap.containsKey(key)) return false;
    Habit habit = habitMap[key]!;
    int curCount = habitCountMap[key] ?? 0;
    if (curCount < habit.maxValue) {
      return true;
    }
    return false;
  }

  bool validateDecrement(
      Map<String, Habit> habitMap, Map<String, int> habitCountMap, String key) {
    if (!habitMap.containsKey(key)) return false;
    Habit habit = habitMap[key]!;
    int curCount = habitCountMap[key] ?? 0;
    if (curCount > 0) {
      return true;
    }
    return false;
  }
}
