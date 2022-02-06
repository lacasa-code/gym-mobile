import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trkar_vendor/main.dart';
import 'package:trkar_vendor/screens/bills/bills.dart';
import 'package:trkar_vendor/screens/items/items.dart';
import 'package:trkar_vendor/screens/Users/coustomer.dart';
import 'package:trkar_vendor/screens/edit_profile.dart';
import 'package:trkar_vendor/screens/faq.dart';
import 'package:trkar_vendor/screens/home.dart';
import 'package:trkar_vendor/screens/packages/packages.dart';
import 'package:trkar_vendor/screens/login.dart';
import 'package:trkar_vendor/screens/product.dart';
import 'package:trkar_vendor/screens/Users/staff.dart';
import 'package:trkar_vendor/screens/stores.dart';
import 'package:trkar_vendor/screens/tickets.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/utils/url_launcher.dart';
import 'package:trkar_vendor/widget/item_hidden_menu.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class HiddenMenu extends StatefulWidget {
  @override
  _HiddenMenuState createState() => _HiddenMenuState();
}

class _HiddenMenuState extends State<HiddenMenu> {
  bool isconfiguredListern = false;
  int id;
  String username, name, roles, last, photo;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        id = prefs.getInt('user_id');
        name = prefs.getString('user_name');
        roles = prefs.getString("roles");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Container(
      color: Colors.white,
      height: ScreenUtil.getHeight(context),
      child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
              color: themeColor.getColor(),
              height: 70,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            //scaffoldKey.currentState.openEndDrawer();
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            size: 35,
                            color: Colors.white,
                          )),
                      InkWell(
                        onTap: (){
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => Home(),
                            ),
                                (route) => false,
                          );                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Image.asset(
                            "assets/images/logo.png",
                            width: ScreenUtil.getWidth(context) / 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(right: 1, left: 1, top: 10),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (scroll) {
                  scroll.disallowGlow();
                  return false;
                },
                child: Column(
                  children: <Widget>[
                    ItemHiddenMenu(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Home(),
                          ),
                              (route) => false,
                        );                          },
                      icon: SvgPicture.asset(
                        "assets/icons/homescreen.svg",
                        height: 30,
                        width: 30,
                        color:  themeColor.getColor(),
                      ),
                      name: getTransrlate(context, 'HomePage'),
                      baseStyle: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected:  themeColor.getColor(),
                    ),
                    roles=='Staff'?Container():  ItemHiddenMenu(
                      onTap: () {

                        Nav.route(context, Coustomers());
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/staff.svg",
                        height: 30,
                        width: 30,
                        color:  themeColor.getColor(),
                      ),
                      name: getTransrlate(context, 'customers'),
                      baseStyle: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected:  themeColor.getColor(),
                    ),
                    roles=='Staff'?Container():  ItemHiddenMenu(
                      onTap: () {

                        Nav.route(context, Staff());
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/staff.svg",
                        height: 30,
                        width: 30,
                        color:  themeColor.getColor(),
                      ),
                      name: getTransrlate(context, 'staf'),
                      baseStyle: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected:  themeColor.getColor(),
                    ),
                    roles=='Staff'?Container():      ItemHiddenMenu(
                      onTap: () {
                        Nav.route(context, Items());
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/orders.svg",
                        height: 30,
                        width: 30,
                        color:  themeColor.getColor(),
                      ),
                      name: getTransrlate(context, 'items'),
                      baseStyle: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected:  themeColor.getColor(),
                    ),
                    roles=='Staff'?Container():      ItemHiddenMenu(
                      onTap: () {
                        Nav.route(context, Packages());
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/invoices.svg",
                        height: 30,
                        width: 30,
                        color:  themeColor.getColor(),
                      ),
                      name: getTransrlate(context, 'packages'),
                      baseStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected:  themeColor.getColor(),
                    ),
                    roles=='Staff'?Container():      ItemHiddenMenu(
                      onTap: () {
                        Nav.route(context, Bills());
                      },
                      icon: Icon(
                        Icons.attach_money,
                        size: 30,
                        color:  themeColor.getColor(),
                      ),
                      name: getTransrlate(context, 'bills'),
                      baseStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected:  themeColor.getColor(),
                    ),
                    roles=='Staff'?Container():      ItemHiddenMenu(
                      onTap: () {
                        Nav.route(context, Packages());
                      },
                      icon:Icon(
                        Icons.payment,
                        size: 30,
                        color:  themeColor.getColor(),
                      ),
                      name: getTransrlate(context, 'payments'),
                      baseStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected:  themeColor.getColor(),
                    ),

                    ItemHiddenMenu(
                      onTap: () {
                        Nav.route(context, Edit_profile());
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/account.svg",
                        height: 30,
                        width: 30,
                        color:  themeColor.getColor(),
                      ),
                      name: getTransrlate(context, 'ProfileSettings'),
                      baseStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected:  themeColor.getColor(),
                    ),
                    ItemHiddenMenu(
                      onTap: () {
                        Nav.route(context, FaqPage());
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/faq.svg",
                        height: 30,
                        width: 30,
                        color:  themeColor.getColor(),
                      ),
                      name: getTransrlate(context, 'FAQ'),
                      baseStyle: TextStyle(
                          color:  themeColor.getColor().withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected:  themeColor.getColor(),
                    ),
                    ItemHiddenMenu(
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
                      icon: SvgPicture.asset(
                        "assets/icons/Log out.svg",
                        height: 30,
                        width: 30,
                        color:  themeColor.getColor(),
                      ),
                      name: themeColor.isLogin
                          ? getTransrlate(context, 'Logout')
                          : getTransrlate(context, 'login'),
                      baseStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected:  themeColor.getColor(),
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
                      color: Colors.black26,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ])),
    );
  }
  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
