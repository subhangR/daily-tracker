import 'package:flutter/material.dart';
import 'package:flutter_application_1/repositories/habit_state_repository.dart';
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

class HistoryScreen extends StatelessWidget {
  HabitStateRepository _habitStateRepository = GetIt.I.get();
  final List<Habit> habits = fetchHabitsData();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HabitStateDao>>(
        future: getData(context),
        builder: (context, AsyncSnapshot<List<HabitStateDao>> snapshot) {
          if (snapshot.hasData) {
            return getScreen(context, snapshot.data!);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<List<HabitStateDao>> getData(BuildContext context) async {
    print("came into get Data");
    var data = await _habitStateRepository.fetchAllHabitStates();
    return data;
  }

  Widget getScreen(
      BuildContext context, List<HabitStateDao> habitStateDaoList) {
    Widget dashboard;
    Map<String, int> emptyMap = HashMap();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(
                icon: const ImageIcon(AssetImage("assets/history.png")),
                tooltip: 'Open History',
                onPressed: () {
                  Navigator.pop(context);
                  // handle the press
                }),
          ],
          title: Text('History'),
        ),
        body: Column(children: [getHistoryView(context, habitStateDaoList)]));
  }

  Widget getHistoryView(
      BuildContext context, List<HabitStateDao> habitStateDaoList) {
    return SizedBox(
        height: 600,
        child: GridView.builder(
          //scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(10.0),
          itemCount: habitStateDaoList.length,
          itemBuilder: (context, i) => getDashboard(
              context,
              habitStateDaoList.elementAt(i).date,
              habitStateDaoList.elementAt(i).habitCountMap),
          // ignore: prefer_const_constructors
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        ));
  }
}
