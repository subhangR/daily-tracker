import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/trackable_item.dart';

class Habit extends TrackableItem {
  String label;
  final String imageAsset;
  final String iconAsset;
  final double multiplier;
  final int maxValue;
  Habit(
    super.metric, {
    required this.label,
    required this.imageAsset,
    this.iconAsset = "",
    required this.multiplier,
    this.maxValue = 1000,
  });
}
