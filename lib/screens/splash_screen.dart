import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trkar_vendor/screens/homepage.dart';
import 'package:trkar_vendor/screens/login.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen();
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Provider_control themeColor;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () => _auth());
  }

  @override
  Widget build(BuildContext context) {
    themeColor = Provider.of<Provider_control>(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: themeColor.getColor(),
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
    );
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: ScreenUtil.getHeight(context) / 2,
                width: ScreenUtil.getWidth(context) / 1.5,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  color: themeColor.getColor(),

                ),
              ),
              Text(
                ' Powered ',
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: themeColor.getColor()),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _auth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    API(context).post('token/data', {}).then((value) {
      if (value != null) {
        var user = value['data']['user'];
        prefs.setString("user_email", user['email']);
        prefs.setString("user_name", user['name']);
        prefs.setInt("user_id", user['id']);
        themeColor.setLogin(true);
        Nav.routeReplacement(context, Home());
      } else {
        themeColor.setLogin(false);
        Nav.routeReplacement(context, LoginPage());
      }
    });
  }
}
