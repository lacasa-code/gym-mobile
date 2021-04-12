import 'package:flutter/material.dart';

class DataRepository {
  static List<double> data = [];
  static List<double> _data = [
    2.2,
    0.7,
    1.4,
    4.3,
    3.2,
  ];

  static List<double> getData() {
    data = _data;
    return _data;
  }

  static void clearData() {
    data = [];
  }

  static List<String> getLabels() {
    List<String> labels = [
      'tu',
      'we',
      'th',
      'fr',
      'sa',
    ];

    return labels;
  }

  static Color getColor(double value) {
    if (value < 2) {
      return Colors.blue.shade300;
    } else if (value < 4) {
      return Colors.blue.shade600;
    } else
      return Colors.blue.shade900;
  }

  static Color getDayColor(int day) {
    if (day < data.length) {
      return getColor(data[day]);
    } else
      return Colors.indigo.shade50;
  }

  static Icon getIcon(double value) {
    if (value < 1) {
      return Icon(
        Icons.star_border,
        size: 24,
        color: getColor(value),
      );
    } else if (value < 2) {
      return Icon(
        Icons.star_half,
        size: 24,
        color: getColor(value),
      );
    } else
      return Icon(
        Icons.star,
        size: 24,
        color: getColor(value),
      );
  }
}
