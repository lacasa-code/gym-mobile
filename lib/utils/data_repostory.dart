import 'package:flutter/material.dart';

class DataRepository {
  static Color getColor(double value) {
    if (value < 2) {
      return Colors.blue.shade300;
    } else if (value < 4) {
      return Colors.blue.shade600;
    } else
      return Colors.blue.shade600;
  }
}
