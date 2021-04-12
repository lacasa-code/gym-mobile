import 'dart:async';
import 'dart:math';

import 'package:chart_components/bar_chart_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trkar_vendor/utils/data_repostory.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<double> data = [];
  List<String> labels = [];
  bool loaded = false;
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: HiddenMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    size: 30,
                  ),
                  color: Colors.blue,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: ScreenUtil.getHeight(context) / 5,
                      width: ScreenUtil.getWidth(context) / 2,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 10,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: ScreenUtil.getHeight(context) / 2,
                child: BarChart(
                  data: data,
                  labels: labels,
                  //dislplayValue: true,
                  reverse: true,
                  getColor: DataRepository.getColor,
                  //getIcon: DataRepository.getIcon,
                  barWidth: 42,
                  barSeparation: 12,
                  animationDuration: Duration(milliseconds: 1800),
                  animationCurve: Curves.easeInOutSine,
                  itemRadius: 30,
                  iconHeight: 24,
                  footerHeight: 24,
                  headerValueHeight: 16,
                  roundValuesOnText: false,
                  //lineGridColor: Colors.lightBlue,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _makePhoneCall('tel:01000000000');
        },
        child: const Icon(Icons.call),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _loadData() {
    setState(() {
      if (!loaded) {
        data = DataRepository.getData();
        loaded = true;
      } else {
        data[data.length - 1] = (Random().nextDouble() * 700).round() / 100;
      }
      labels = DataRepository.getLabels();
    });
  }
}
