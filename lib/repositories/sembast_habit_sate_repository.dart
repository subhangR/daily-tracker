import 'package:flutter_application_1/models/habit_state_dao.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'habit_state_repository.dart';
import '../models/providers/habit_state.dart';
import 'dart:collection';

class SembastHabitStateRepository extends HabitStateRepository {
  final Database _database = GetIt.instance.get();
  final StoreRef _habitStateStore =
      stringMapStoreFactory.store("habit_state_store");

  SembastHabitStateRepository() {}

  @override
  Future updateHabitState(HabitStateDao habitStateDao) async {
    print(
        "Saving Record!! ${habitStateDao.date} ${habitStateDao.habitCountMap}");
    await _habitStateStore
        .record(habitStateDao.date)
        .put(_database, habitStateDao.toMap());
    // final snapshots = await _habitStateStore.find(_database);
    // snapshots.map((snapshot) => print(snapshot)).toList(growable: false);
  }

  @override
  Future<HabitStateDao?> fetchHabitState(String key) async {
    Map<String, int>? emptyMap = null;
    try {
      var result = await _habitStateStore.record(key).get(_database) as Map;
      print("result = ${result}");
      if (result == null) return null;
      emptyMap = result
          .map((key, value) => MapEntry(key, int.parse(value!.toString())));
      return HabitStateDao(key, emptyMap);
    } catch (err) {
      print("error while fetchign data ${err}");
    }
    return null;
  }

  @override
  Future<List<HabitStateDao>> fetchAllHabitStates() async {
    try {
      print("Fetching All Records!");
      var finder = Finder(sortOrders: [SortOrder('date')]);
      var records = await _habitStateStore.find(_database, finder: finder);
      print("Fetched All Records! ${records}");
      if (records.length == 0) {
        return List.empty();
      }
      List<HabitStateDao> habitStateList = List.empty(growable: true);
      records.forEach((element) {
        Map<String, dynamic> habitCountMapRaw = Map.from(element.value);
        Map<String, int> habitCount = habitCountMapRaw
            .map((key, value) => MapEntry(key, int.parse(value!.toString())));
        habitStateList.add(HabitStateDao(element.key, habitCount));
      });
      return habitStateList;
    } catch (err) {
      print("Error Occurred When fetching All Records ${err}");
      return List.empty();
    }
  }
}
