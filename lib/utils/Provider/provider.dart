import 'package:flutter/material.dart';

class Provider_control with ChangeNotifier {
  Color _themeData = Colors.blueGrey;
  String local = 'en';
  bool isLogin = false;

  Provider_control();

  getColor() => _themeData;
  getlocal() => local;

  setColor(Color themeData) async {
    _themeData = themeData;
    notifyListeners();
  }

  setLogin(bool isLog) {
    isLogin = isLog;
    notifyListeners();
  }

  setLocal(String st) {
    local = st;
    notifyListeners();
  }
}
