import 'dart:async';

import 'package:flutter/cupertino.dart';

class Search {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Search({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}