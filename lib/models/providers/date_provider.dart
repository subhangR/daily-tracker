import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/models/habit.dart';
import 'package:flutter_application_1/models/trackable_item.dart';
import '../../static_data/habits_data.dart';

class DateState extends ChangeNotifier {
  late String date;

  DateState(String date) {
    this.date = date;
  }

  void updateDate(String date) {
    this.date = date;
    notifyListeners();
  }
}
