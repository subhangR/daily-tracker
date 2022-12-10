import 'providers/habit_state.dart';

class HabitStateDao {
  final String date;
  late Map<String, int> habitCountMap;
  HabitStateDao(this.date, this.habitCountMap) {}

  toMap() {
    return habitCountMap;
  }

  debug(String label) {
    print("HabitStateDao ${label} - date - ${date} , map - ${habitCountMap}");
  }
}
