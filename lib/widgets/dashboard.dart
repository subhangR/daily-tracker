import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/date_util.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../models/providers/habit_state.dart';
import 'dart:collection';

final int ANIMATION_DURATION = 500;
final int maxPoints = 100;
Widget getDashboard(
    BuildContext context, String date, Map<String, int> habitCountMapping) {
  print(
      "Creating Dashboard With date- ${date} habitCountMapping- ${habitCountMapping}");
  Map<String, int> habitCount = HashMap();
  late String dashboardDate = date;
  if (habitCountMapping != null) {
    habitCount = habitCountMapping;
  }
  if (DateUtil.getDateString(DateTime.now()) == date) {
    habitCount = context.watch<HabitState>().habitCountMapping;
    dashboardDate = context.watch<HabitState>().date;
  }
  return GestureDetector(
      onTap: () {/* Write listener code here */},
      child: getDashboardContainer(dashboardDate, habitCount));
}

Widget getDashboardContainer(
    String dashboardDate, Map<String, int> habitCount) {
  return Container(
      height: 250,
      width: double.infinity,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
            elevation: 20,
            child: Column(
              children: [
                Text('${dashboardDate}'),
                Expanded(
                  flex: 3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          getPercentIndicator("assets/heart_icon.png",
                              getHealthPoints(habitCount), maxPoints),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${getHealthPoints(habitCount)}",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.purple),
                              ),
                              Text(
                                "",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          getPercentIndicator("assets/gears_icon.png",
                              getProductivityPoints(habitCount), maxPoints),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${getProductivityPoints(habitCount)}",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.purple),
                              ),
                              Text(
                                "",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          getPercentIndicator("assets/other_icon.png",
                              getTasksPoints(habitCount), maxPoints),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${getTasksPoints(habitCount)}",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.purple),
                              ),
                              Text(
                                "",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(children: [
                    getLinearPercentIndicator(
                        getTotalPoints(habitCount), maxPoints)
                  ]),
                )
              ],
            ),
          )));
}

Widget getPercentIndicator(String asset, double curPoints, int maxPoints) {
  double normalizedCurpoints = curPoints.abs();

  Color progressColor = (curPoints > 0) ? Colors.green : Colors.red;
  double percentage = normalizedCurpoints.toDouble() / maxPoints.toDouble();
  if (percentage <= 0) {
    percentage = 0.0;
  }
  if (percentage >= 1) {
    percentage = 1.0;
  }
  return Container(
    padding: EdgeInsets.all(15.0),
    child: CircularPercentIndicator(
      animation: true,
      animationDuration: ANIMATION_DURATION,
      lineWidth: 20,
      percent: percentage,
      center: CircleAvatar(
        radius: 30.0,
        backgroundImage: AssetImage(asset),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: Colors.yellow,
      progressColor: progressColor,
      radius: 40,
    ),
  );
}

Widget getLinearPercentIndicator(double curPoints, int maxPoints) {
  double normalizedCurPoints = curPoints.abs();
  Color progressColor = (curPoints > 0) ? Colors.blue : Colors.redAccent;
  double percentage = normalizedCurPoints.toDouble() / maxPoints.toDouble();
  if (percentage < 0) {
    percentage = 0.0;
  }
  if (percentage >= 1) {
    percentage = 1.0;
  }
  return Container(
    padding: EdgeInsets.all(15.0),
    child: LinearPercentIndicator(
      animation: true,
      leading: const Text("Total"),
      center: Text("${curPoints}/${maxPoints}"),
      width: 300.0,
      animationDuration: ANIMATION_DURATION,
      lineHeight: 15.0,
      percent: percentage,
      barRadius: Radius.circular(10.0),
      progressColor: progressColor,
    ),
  );
}

double getHealthPoints(Map<String, int> habitCount) {
  int cigCount = habitCount["cigaratte"] ?? 0;
  int jointCount = habitCount["joint"] ?? 0;
  int pornCount = habitCount["porn"] ?? 0;
  int exerciseCount = habitCount["exercise"] ?? 0;
  int cbtCount = habitCount["cbt"] ?? 0;
  int waterCount = habitCount["water"] ?? 0;
  int fnfCount = habitCount["fnf"] ?? 0;

  return -5 * cigCount -
      4 * jointCount -
      5 * pornCount +
      3 * exerciseCount +
      3.2 * cbtCount +
      4 * waterCount +
      3.2 * fnfCount;
}

double getProductivityPoints(Map<String, int> habitCount) {
  return 2.5 *
      ((habitCount["coding"] ?? 0) +
          (habitCount["productivity"] ?? 0) +
          (habitCount["piano"] ?? 0));
}

double getTotalPoints(Map<String, int> habitCount) {
  return (getHealthPoints(habitCount) * 0.5 +
      getProductivityPoints(habitCount) * 0.3 +
      getTasksPoints(habitCount) * 0.2);
}

double getTasksPoints(Map<String, int> habitCount) {
  return (habitCount["brush"] ?? 0) * 5 +
      (habitCount["bath"] ?? 0) * 5 +
      (habitCount["room_cleaning"] ?? 0) * 5 +
      (habitCount["washing_clothes"] ?? 0) * 5 +
      (habitCount["hair_care"] ?? 0) * 20 +
      (habitCount["tasks"] ?? 0) * 10;
}
/*
//Health

1) cigaratte -> w = -50 (0 - 12)
2) weed -> w = -40  (0 - 5)
3) porn -> w = -50 (0 -4)
4) exercise -> w = 30 (0-12)
5) cbt -> w = 32
6) water -> w = 40
7) fnf -> w = 32

//Productivity
1) software development - 100
2) Piano - 100
3) Other productivity -> learning / buisness. - 100


//other
1) Brush - (max 2) w = 50 
2) Bath - (max 2) w = 50
3) Room cleaning -> (max 1) w = 50
4) Washing clothes -> (max 1) w = 50
5) Hair care -> (max 2) w = 200
6) Task -> (max 3) w = 100

*/
