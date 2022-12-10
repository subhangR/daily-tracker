import 'package:flutter/material.dart';
import 'package:flutter_application_1/repositories/habit_state_repository.dart';
import 'package:flutter_application_1/services/habit_state_service.dart';
import 'package:get_it/get_it.dart';
import '../models/providers/habit_state.dart';
import 'package:flutter_application_1/models/trackable_item.dart';
import 'package:provider/provider.dart';
import '../widgets/cards/CounterCard.dart';
import '../widgets/dashboard.dart';
import '../models/habit.dart';
import '../static_data/habits_data.dart';
import '../models/init.dart';
import '../models/habit_state_dao.dart';
import '../util/date_util.dart';
import 'dart:collection';
import '../models/providers/date_provider.dart';

class TrackerScreen extends StatelessWidget {
  HabitStateService _habitStateService = GetIt.I.get();
  final List<Habit> habits = fetchHabitsData();

  TrackerScreen() {}

  @override
  Widget build(BuildContext context) {
    print("Building TrackerScreen!");
    return FutureBuilder<HabitStateDao>(
        future: getData(context),
        builder: (context, AsyncSnapshot<HabitStateDao> snapshot) {
          if (snapshot.hasData) {
            print("SnapshotData - ${snapshot.data!}");
            return getScreen(context, snapshot.data!);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<HabitStateDao> getData(BuildContext context) async {
    print("came into get Data");
    String currentDate = DateUtil.getDateString(DateTime.now());
    HabitStateDao? habitStateDao =
        await _habitStateService.fetchHabitStateDao(currentDate);
    habitStateDao ??= HabitStateDao(currentDate, HashMap());
    context
        .read<HabitState>()
        .updateState(habitStateDao.date, habitStateDao.habitCountMap);
    return habitStateDao;
  }

  Widget getScreen(BuildContext context, HabitStateDao habitStateDao) {
    Widget dashboard =
        getDashboard(context, habitStateDao.date, habitStateDao.habitCountMap);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(
                icon: const ImageIcon(AssetImage("assets/history.png")),
                tooltip: 'Open History',
                onPressed: () {
                  Navigator.pushNamed(context, '/history');
                  // handle the press
                }),
          ],
          leading: GestureDetector(
            onTap: () {/* Write listener code here */},
            child: Icon(
              Icons.menu, // add custom icons also
            ),
          ),
          title: Text('Daily Tracker'),
        ),
        body: Column(children: [
          dashboard,
          Expanded(
              child: getTrackerView(habitStateDao.date, habits, habitStateDao))
        ]));
  }

  Widget getTrackerView(
      String date, List<Habit> habits, HabitStateDao habitStateDao) {
    return SizedBox(
        height: 400,
        child: GridView.builder(
          //scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(10.0),
          itemCount: habits.length,
          itemBuilder: (context, i) => CounterCard(
              date,
              habits[i].label,
              habits[i].imageAsset,
              habits[i].metric,
              true,
              habitStateDao.habitCountMap),
          // ignore: prefer_const_constructors
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        ));
  }
}

Widget getIconContainer(Habit h) {
  return Container(
    child: Wrap(
      direction: Axis.vertical,
      //crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.ltr,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [getIcon(h.iconAsset), getText(h)],
    ),
  );
}

Widget getText(Habit h) {
  if (h.label.startsWith("cigaratte")) {
    return Text("0");
  }
  return SizedBox.shrink();
}

Widget getIcon(String imageAsset) {
  return CircleAvatar(
    backgroundColor: Colors.greenAccent,
    child: Material(
      elevation: 10,
      child: CircleAvatar(
          radius: 10,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(imageAsset)),
    ),
  );
}
