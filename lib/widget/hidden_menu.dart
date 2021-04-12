import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trkar_vendor/main.dart';
import 'package:trkar_vendor/screens/login.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/item_hidden_menu.dart';

// ignore: must_be_immutable
class HiddenMenu extends StatefulWidget {
  @override
  _HiddenMenuState createState() => _HiddenMenuState();
}

class _HiddenMenuState extends State<HiddenMenu> {
  bool isconfiguredListern = false;
  int id;
  String username, name, last, photo;
  String am_pm;

  @override
  void initState() {
    am_pm = new DateFormat('a').format(new DateTime.now());
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        id = prefs.getInt('user_id');
        name = prefs.getString('user_name');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Drawer(
      child: Container(
        color: Colors.blueAccent,
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
          SizedBox(
            height: ScreenUtil.getHeight(context) / 10,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: ListTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoSizeText(
                    //  getTransrlate(context, 'welcome'),
                    am_pm == 'am'
                        ? getTransrlate(context, 'good_morning')
                        : getTransrlate(context, 'good_night'),
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  AutoSizeText(
                    name == null ? getTransrlate(context, 'gust') : name,
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (scroll) {
                scroll.disallowGlow();
                return false;
              },
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: ItemHiddenMenu(
                      icon: Icon(
                        Icons.person,
                        size: 25,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      name: getTransrlate(context, 'ProfileSettings'),
                      baseStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected: Colors.orange,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: ItemHiddenMenu(
                      icon: Icon(
                        Icons.call,
                        size: 25,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      name: getTransrlate(context, 'contact'),
                      baseStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected: Colors.orange,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: ItemHiddenMenu(
                      icon: Icon(
                        Icons.info_outline,
                        size: 25,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      name: getTransrlate(context, 'About'),
                      baseStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected: Colors.orange,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (themeColor.isLogin) {
                        themeColor.setLogin(false);
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        API(context).post('logout', {});
                        prefs.clear();
                        Nav.routeReplacement(context, LoginPage());
                      } else {
                        Nav.route(context, LoginPage());
                      }
                    },
                    child: ItemHiddenMenu(
                      icon: Icon(
                        Icons.exit_to_app,
                        size: 19,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      name: themeColor.isLogin
                          ? getTransrlate(context, 'Logout')
                          : getTransrlate(context, 'login'),
                      baseStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected: Colors.orange,
                    ),
                  ),
                  Container(
                      height: 28,
                      margin: EdgeInsets.only(left: 24, right: 48),
                      child: Divider(
                        color: Colors.white.withOpacity(0.5),
                      )),
                  Container(
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (scroll) {
                        scroll.disallowGlow();
                        return false;
                      },
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0.0),
                        children: <Widget>[
                          InkWell(
                            onTap: () async {
                              await themeColor.local == 'ar'
                                  ? themeColor.setLocal('en')
                                  : themeColor.setLocal('ar');
                              MyApp.setlocal(
                                  context, Locale(themeColor.getlocal(), ''));
                              SharedPreferences.getInstance().then((prefs) {
                                prefs.setString('local', themeColor.local);
                              });
                            },
                            child: ItemHiddenMenu(
                              icon: Icon(
                                Icons.language,
                                size: 25,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              name: Provider.of<Provider_control>(context)
                                          .local ==
                                      'ar'
                                  ? 'English'
                                  : 'عربى',
                              baseStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w800),
                              colorLineSelected: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getTransrlate(context, 'version') + ' 1.0.0',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white60,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ])),
      ),
    );
  }
}
