import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/habit.dart';
import 'package:flutter_application_1/repositories/habit_state_repository.dart';
import '../../models/trackable_item.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../models/providers/habit_state.dart';
import 'package:get_it/get_it.dart';
import '../../models/habit_state_dao.dart';
import '../../util/date_util.dart';
import '../../services/habit_state_service.dart';
import '../../models/providers/date_provider.dart';

class CounterCard extends StatelessWidget {
  final String imageAsset;
  final String label;
  final String date;
  final bool isEditable;
  final Metric metric;
  final int step = 1;
  final Map<String, int> habitCountMap;
  HabitStateService habitStateService = GetIt.I.get();

  CounterCard(this.date, this.label, this.imageAsset, this.metric,
      this.isEditable, this.habitCountMap);

  @override
  Widget build(BuildContext context) {
    Map<String, int> currentMap = habitCountMap;
    if (date == DateUtil.getDateString(DateTime.now())) {
      currentMap = context.watch<HabitState>().habitCountMapping;
    }
    String currentValue =
        context.read<HabitState>().getValue(currentMap, label);
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
          splashColor: Colors.green,
          onTap: () => handlePress(context),
          onLongPress: () => handleLongPress(context),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Image.asset(
                  imageAsset,
                  fit: BoxFit.contain,
                )),
                Text("${currentValue}"),
              ],
            ),
          )),
    );
  }

  void handlePress(BuildContext context) async {
    if (isEditable) {
      HabitStateDao? habitStateDao =
          await habitStateService.fetchHabitStateDao(date);
      print("HabitStateDao after Press From database - ${habitStateDao}");
      HabitStateDao updatedHabitStateDao =
          await habitStateService.incrementHabit(label, habitStateDao);
      context.read<HabitState>().updateState(
          updatedHabitStateDao.date, updatedHabitStateDao.habitCountMap);
    }
  }

  void handleLongPress(BuildContext context) async {
    if (isEditable) {
      HabitStateDao? habitStateDao =
          await habitStateService.fetchHabitStateDao(date);
      print("HabitStateDao after Press From database - ${habitStateDao}");
      HabitStateDao updatedHabitStateDao =
          await habitStateService.decrementHabit(label, habitStateDao);
      context.read<HabitState>().updateState(
          updatedHabitStateDao.date, updatedHabitStateDao.habitCountMap);
    }
  }
}
