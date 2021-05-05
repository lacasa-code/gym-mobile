import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:trkar_vendor/screens/homedesktop.dart';
import 'package:trkar_vendor/screens/homepage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      breakpoints: ScreenBreakpoints(tablet: 600, desktop: 1460, watch: 300),
      mobile: HomeMobile(),
      desktop: HomeDesktop(),
      tablet: HomeDesktop(),
    );
  }
}
