import 'package:flutter_application_1/models/habit_state_dao.dart';

import '../models/providers/habit_state.dart';

abstract class HabitStateRepository {
  Future updateHabitState(HabitStateDao habitState);
  Future<HabitStateDao?> fetchHabitState(String key);
  Future<List<HabitStateDao>> fetchAllHabitStates();
}
