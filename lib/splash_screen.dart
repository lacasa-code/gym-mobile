import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trkar_vendor/screens/home.dart';
import 'package:trkar_vendor/screens/login.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    Timer(Duration(seconds: 1), () => _auth());
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
      backgroundColor: themeColor.getColor(),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          image: DecorationImage(
            image: new ExactAssetImage('assets/images/splashscreen.png'),
            fit: BoxFit.cover,
          ),
          color: Color(0xff27332F),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 20),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                   height: ScreenUtil.getHeight(context) / 8,
                ),
                Container(
               //   height: ScreenUtil.getHeight(context) / 2,
                  width: ScreenUtil.getWidth(context) / 1.5,
                  child: Image.asset(
                    'assets/images/splashscreen-trkar-logo-white.gif',
                  ),
                ),
                Container(
                  width: ScreenUtil.getWidth(context) / 1.5,

                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('vendor',style: TextStyle(color: Colors.white),),
                      Text('البائع',style: TextStyle(color: Colors.white),),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _auth() async {

    //themeColor.setCar_made(getTransrlate(context, 'selectCar'));
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();
    API(context).post('check/valid/session', {}).then((value) {
      if (value != null) {
        print("dddddddd ${value['data']}");
        if (value['status_code'] == 200)
      {
        // Provider.of<Provider_Data>(context,listen: false).getAllstaff(context);
        // Provider.of<Provider_Data>(context,listen: false).getAllStore(context);
        // Provider.of<Provider_Data>(context,listen: false).getProducts(context);

        var user = value['data'];
        prefs.setString("user_email", user['email']);
        prefs.setString("user_name", user['name']);
        prefs.setInt("user_id", user['id']);
        prefs.setString("roles", user['roles'][0]['title']);
        Provider.of<Provider_control>(context,listen: false).setLogin(true);
        Nav.routeReplacement(context, Home());
      }else {
        Provider.of<Provider_control>(context,listen: false).setLogin(false);
        Nav.routeReplacement(context, LoginPage());
      }}
    });
  }

}
