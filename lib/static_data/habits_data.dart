import '../models/habit.dart';
import 'dart:collection';
import '../models/trackable_item.dart';

List<Habit> fetchHabitsData() {
  return [
    //Health
    Habit(
        label: "cigaratte",
        imageAsset: "assets/cigaratte.png",
        iconAsset: "assets/cigaratte.png",
        Metric.unit,
        multiplier: 1),
    Habit(
      label: "joint",
      imageAsset: "assets/joint.png",
      iconAsset: "assets/joint_icon.jpg",
      Metric.unit,
      multiplier: 1,
    ),
    Habit(
      label: "porn",
      imageAsset: "assets/porn.png",
      iconAsset: "assets/joint_icon.jpg",
      Metric.unit,
      multiplier: 1,
    ),
    Habit(
        label: "exercise",
        imageAsset: "assets/exercise.png",
        iconAsset: "assets/exercise_icon.png",
        Metric.hrs,
        multiplier: 0.25,
        maxValue: 12),
    Habit(
        label: "cbt",
        imageAsset: "assets/cbt.webp",
        Metric.unit,
        multiplier: 1,
        maxValue: 5),

    Habit(
        label: "water",
        imageAsset: "assets/water.png",
        Metric.ltrs,
        multiplier: 0.5,
        maxValue: 8),

    Habit(
      label: "fnf",
      imageAsset: "assets/fnf.png",
      Metric.unit,
      multiplier: 1,
      maxValue: 5,
    ),

    //productivity
    Habit(
      label: "coding",
      imageAsset: "assets/coding_icon.png",
      Metric.hrs,
      multiplier: 0.25,
      maxValue: 40,
    ),

    Habit(
      label: "productivity",
      imageAsset: "assets/learning.jpg",
      Metric.hrs,
      multiplier: 0.25,
      maxValue: 40,
    ),

    Habit(
      label: "piano",
      imageAsset: "assets/piano.png",
      Metric.hrs,
      multiplier: 0.25,
      maxValue: 8,
    ),

    //The little things

    Habit(
        label: "brush",
        imageAsset: "assets/brush.png",
        Metric.unit,
        multiplier: 1,
        maxValue: 2),

    Habit(
        label: "bath",
        imageAsset: "assets/bath.png",
        Metric.unit,
        multiplier: 1,
        maxValue: 2),

    Habit(
        label: "room_cleaning",
        imageAsset: "assets/room_cleaning.png",
        Metric.unit,
        multiplier: 1,
        maxValue: 1),

    Habit(
        label: "washing_clothes",
        imageAsset: "assets/clothes.jpg",
        Metric.unit,
        multiplier: 1,
        maxValue: 1),

    Habit(
        label: "hair_care",
        imageAsset: "assets/hair.webp",
        Metric.unit,
        multiplier: 1,
        maxValue: 2),

    Habit(
        label: "tasks",
        imageAsset: "assets/task.png",
        Metric.unit,
        multiplier: 1,
        maxValue: 3),
  ];
}

Map<String, Habit> fetchHabitMap() {
  Map<String, Habit> habitMap = HashMap();
  List<Habit> habits = fetchHabitsData();
  for (int i = 0; i < habits.length; i++) {
    habitMap[habits[i].label] = habits[i];
  }
  return habitMap;
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

