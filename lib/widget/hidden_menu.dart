import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trkar_vendor/main.dart';
import 'package:trkar_vendor/screens/Orders.dart';
import 'package:trkar_vendor/screens/edit_profile.dart';
import 'package:trkar_vendor/screens/faq.dart';
import 'package:trkar_vendor/screens/home.dart';
import 'package:trkar_vendor/screens/invoices.dart';
import 'package:trkar_vendor/screens/login.dart';
import 'package:trkar_vendor/screens/product.dart';
import 'package:trkar_vendor/screens/staff.dart';
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
                        color: Colors.blue,
                      ),
                      name: getTransrlate(context, 'HomePage'),
                      baseStyle: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected: Colors.blue,
                    ),
                    ItemHiddenMenu(
                      onTap: () {
                        Nav.route(context, Stores());
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/store.svg",
                        height: 30,
                        width: 30,
                        color: Colors.blue,
                      ),
                      name: getTransrlate(context, 'stores'),
                      baseStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected: Colors.black,
                    ),
                    roles=='Staff'?Container():  ItemHiddenMenu(
                      onTap: () {

                        Nav.route(context, Staff());
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/staff.svg",
                        height: 30,
                        width: 30,
                        color: Colors.blue,
                      ),
                      name: getTransrlate(context, 'staff'),
                      baseStyle: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected: Colors.blue,
                    ),
                    roles=='Staff'?Container():      ItemHiddenMenu(
                      onTap: () {
                        Nav.route(context, Orders());
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/orders.svg",
                        height: 30,
                        width: 30,
                        color: Colors.blue,
                      ),
                      name: getTransrlate(context, 'Myorders'),
                      baseStyle: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected: Colors.blue,
                    ),
                    // ItemHiddenMenu(
                    //   onTap: () {
                    //     Nav.route(context, Products());
                    //   },
                    //   icon: SvgPicture.asset(
                    //     "assets/icons/products.svg",
                    //     height: 30,
                    //     width: 30,
                    //     color: Colors.blue,
                    //   ),
                    //   name: getTransrlate(context, 'products'),
                    //   baseStyle: TextStyle(
                    //       color: Colors.black.withOpacity(0.6),
                    //       fontSize: 19.0,
                    //       fontWeight: FontWeight.w800),
                    //   colorLineSelected: Colors.blue,
                    // ),
                    roles=='Staff'?Container():      ItemHiddenMenu(
                      onTap: () {
                        Nav.route(context, Invoices());
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/invoices.svg",
                        height: 30,
                        width: 30,
                        color: Colors.blue,
                      ),
                      name: getTransrlate(context, 'invoices'),
                      baseStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected: Colors.blue,
                    ),
                    // ItemHiddenMenu(
                    //   onTap: () {
                    //     Nav.route(context, Tickets());
                    //   },
                    //   icon: SvgPicture.asset(
                    //     "assets/icons/tickets.svg",
                    //     height: 30,
                    //     width: 30,
                    //     color: Colors.blue,
                    //   ),
                    //   name: getTransrlate(context, 'ticket'),
                    //   baseStyle: TextStyle(
                    //       color: Colors.white.withOpacity(0.6),
                    //       fontSize: 19.0,
                    //       fontWeight: FontWeight.w800),
                    //   colorLineSelected: Colors.blue,
                    // ),
                    ItemHiddenMenu(
                      onTap: () {
                        Nav.route(context, FaqPage());
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/faq.svg",
                        height: 30,
                        width: 30,
                        color: Colors.blue,
                      ),
                      name: getTransrlate(context, 'FAQ'),
                      baseStyle: TextStyle(
                          color: Colors.blue.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected: Colors.blue,
                    ),

                    ItemHiddenMenu(
                      onTap: () {
                        Nav.route(context, Edit_profile());
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/account.svg",
                        height: 30,
                        width: 30,
                        color: Colors.blue,
                      ),
                      name: getTransrlate(context, 'ProfileSettings'),
                      baseStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected: Colors.blue,
                    ),
                    // Container(
                    //   child:
                    //   NotificationListener<OverscrollIndicatorNotification>(
                    //     onNotification: (scroll) {
                    //       scroll.disallowGlow();
                    //       return false;
                    //     },
                    //     child: ListView(
                    //       shrinkWrap: true,
                    //       padding: EdgeInsets.all(0.0),
                    //       children: <Widget>[
                    //         InkWell(
                    //           onTap: () async {
                    //             await themeColor.local == 'ar'
                    //                 ? themeColor.setLocal('en')
                    //                 : themeColor.setLocal('ar');
                    //             MyApp.setlocal(
                    //                 context, Locale(themeColor.getlocal(), ''));
                    //             SharedPreferences.getInstance().then((prefs) {
                    //               prefs.setString('local', themeColor.local);
                    //             });
                    //             Navigator.pop(context);
                    //
                    //           },
                    //           child: ItemHiddenMenu(
                    //             icon: SvgPicture.asset(
                    //               "assets/icons/globe (1).svg",
                    //               height: 25,
                    //               width: 25,
                    //               color: Colors.blue,
                    //             ),
                    //             name: Provider.of<Provider_control>(context)
                    //                 .local ==
                    //                 'ar'
                    //                 ? 'English'
                    //                 : 'عربى',
                    //             baseStyle: TextStyle(
                    //                 color: Colors.white.withOpacity(0.6),
                    //                 fontSize: 19.0,
                    //                 fontWeight: FontWeight.w800),
                    //             colorLineSelected: Colors.blue,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    // InkWell(
                    //   onTap: (){
                    //   //  launchURL('tel:+201111511190');
                    //     _launchURL('https://www.instagram.com/');
                    //   },
                    //   child: ItemHiddenMenu(
                    //     icon: SvgPicture.asset(
                    //       "assets/icons/Call.svg",
                    //       height: 30,
                    //       width: 30,
                    //       color: Colors.blue,
                    //     ),
                    //     name: getTransrlate(context, 'contact'),
                    //     baseStyle: TextStyle(
                    //         color: Colors.white.withOpacity(0.6),
                    //         fontSize: 19.0,
                    //         fontWeight: FontWeight.w800),
                    //     colorLineSelected: Colors.blue,
                    //   ),
                    // ),
                    ItemHiddenMenu(
                      onTap: () {
                        Nav.route(context, FaqPage());
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/faq.svg",
                        height: 30,
                        width: 30,
                        color: Colors.blue,
                      ),
                      name: getTransrlate(context, 'FAQ'),
                      baseStyle: TextStyle(
                          color: Colors.blue.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected: Colors.blue,
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
                        color: Colors.blue,
                      ),
                      name: themeColor.isLogin
                          ? getTransrlate(context, 'Logout')
                          : getTransrlate(context, 'login'),
                      baseStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800),
                      colorLineSelected: Colors.blue,
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
