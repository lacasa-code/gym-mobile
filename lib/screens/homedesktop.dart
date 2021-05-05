import 'package:auto_size_text/auto_size_text.dart';
import 'package:chart_components/bar_chart_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trkar_vendor/main.dart';
import 'package:trkar_vendor/model/basic_report.dart';
import 'package:trkar_vendor/screens/Orders.dart';
import 'package:trkar_vendor/screens/edit_profile.dart';
import 'package:trkar_vendor/screens/faq.dart';
import 'package:trkar_vendor/screens/invoices.dart';
import 'package:trkar_vendor/screens/login.dart';
import 'package:trkar_vendor/screens/product.dart';
import 'package:trkar_vendor/screens/staff.dart';
import 'package:trkar_vendor/screens/stores.dart';
import 'package:trkar_vendor/screens/tickets.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/data_repostory.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/commons/default_button.dart';
import 'package:trkar_vendor/widget/item_hidden_menu.dart';

class HomeDesktop extends StatefulWidget {
  @override
  _HomeDesktopState createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<double> data = [];
  List<String> labels = [];
  bool loaded = false;
  Basic_report basic_report;
  DateTime date = DateTime.now();
  DateTime from = DateTime.now();
  TextEditingController _tocontroller = TextEditingController();
  TextEditingController _fromcontroller = TextEditingController();
  bool isconfiguredListern = false;
  int id;
  String username, name, last, photo;
  String am_pm;

  Future<void> _selectDatefrom(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: date);
    if (picked != null && picked != date)
      setState(() {
        _fromcontroller.text = DateFormat('yyyy-MM-dd').format(picked);
        from = picked;
      });
  }

  Future<void> _selectDateto(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context, initialDate: date, firstDate: from, lastDate: date);
    print("${DateFormat('yyyy-MM-dd').format(picked)}");

    if (picked != null)
      setState(() {
        _tocontroller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  @override
  void initState() {
    get_report(DateFormat('yyyy-MM-dd').format(DateTime.now()),
        DateFormat('yyyy-MM-dd').format(DateTime.now()));
    am_pm = DateFormat('a').format(new DateTime.now());
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

    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: [
          Container(
            width: ScreenUtil.getWidth(context) / 5,
            height: ScreenUtil.getHeight(context) / 1,
            color: themeColor.getColor(),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/logo.png',
                              color: Colors.white,
                              height: ScreenUtil.getHeight(context) / 8,
                              fit: BoxFit.contain,
                            ),
                          ),
                          AutoSizeText(
                            //  getTransrlate(context, 'welcome'),
                            am_pm == 'AM'
                                ? getTransrlate(context, 'good_morning')
                                : getTransrlate(context, 'good_night'),
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            name == null
                                ? getTransrlate(context, 'gust')
                                : name,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Nav.route(context, Staff());
                        },
                        child: ItemHiddenMenu(
                          icon: Icon(
                            Icons.supervised_user_circle,
                            size: 25,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          name: getTransrlate(context, 'staff'),
                          baseStyle: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 19.0,
                              fontWeight: FontWeight.w800),
                          colorLineSelected: Colors.orange,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Nav.route(context, Stores());
                        },
                        child: ItemHiddenMenu(
                          icon: Icon(
                            Icons.store,
                            size: 25,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          name: getTransrlate(context, 'stores'),
                          baseStyle: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 19.0,
                              fontWeight: FontWeight.w800),
                          colorLineSelected: Colors.orange,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Nav.route(context, Products());
                        },
                        child: ItemHiddenMenu(
                          icon: Icon(
                            Icons.shopping_bag,
                            size: 25,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          name: getTransrlate(context, 'product'),
                          baseStyle: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 19.0,
                              fontWeight: FontWeight.w800),
                          colorLineSelected: Colors.orange,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Nav.route(context, Orders());
                        },
                        child: ItemHiddenMenu(
                          icon: Icon(
                            Icons.shopping_cart,
                            size: 25,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          name: getTransrlate(context, 'Myorders'),
                          baseStyle: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 19.0,
                              fontWeight: FontWeight.w800),
                          colorLineSelected: Colors.orange,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Nav.route(context, Invoices());
                        },
                        child: ItemHiddenMenu(
                          icon: Icon(
                            Icons.assignment_sharp,
                            size: 25,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          name: getTransrlate(context, 'invoices'),
                          baseStyle: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 19.0,
                              fontWeight: FontWeight.w800),
                          colorLineSelected: Colors.orange,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Nav.route(context, Tickets());
                        },
                        child: ItemHiddenMenu(
                          icon: Icon(
                            Icons.message,
                            size: 25,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          name: getTransrlate(context, 'ticket'),
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
                      InkWell(
                        onTap: () {
                          Nav.route(context, Edit_profile());
                        },
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
                        onTap: () {
                          Nav.route(context, FaqPage());
                        },
                        child: ItemHiddenMenu(
                          icon: Icon(
                            Icons.info_outline,
                            size: 25,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          name: getTransrlate(context, 'FAQ'),
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
                        child: NotificationListener<
                            OverscrollIndicatorNotification>(
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
                                  MyApp.setlocal(context,
                                      Locale(themeColor.getlocal(), ''));
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
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: ScreenUtil.getHeight(context) / 10,
                ),
                Text(DateFormat('yyyy-MM-dd').format(DateTime.now())),
                Container(
                  width: ScreenUtil.getWidth(context) / 3,
                  child: DefaultButton(
                      text: getTransrlate(context, 'filter'),
                      press: () {
                        final _formKey = GlobalKey<FormState>();

                        showDialog(
                          context: context,
                          builder: (BuildContext contex) {
                            return AlertDialog(
                              title: Text('Filter Sales by period'),
                              content: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 10),
                                    TextFormField(
                                        readOnly: true,
                                        onTap: () => _selectDatefrom(context),
                                        controller: _fromcontroller,
                                        decoration: InputDecoration(
                                          suffixIcon:
                                              Icon(Icons.calendar_today),
                                          hintText: 'date',
                                          contentPadding: EdgeInsets.all(15.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          fillColor: Color(0xFFEEEEF3),
                                          labelText: 'from',
                                          filled: true,
                                        ),
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'from required';
                                          }
                                          _formKey.currentState.save();

                                          return null;
                                        }),
                                    SizedBox(height: 10),
                                    TextFormField(
                                        readOnly: true,
                                        onTap: () => _selectDateto(context),
                                        controller: _tocontroller,
                                        decoration: InputDecoration(
                                          suffixIcon:
                                              Icon(Icons.calendar_today),
                                          hintText: 'date',
                                          contentPadding: EdgeInsets.all(15.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          fillColor: Color(0xFFEEEEF3),
                                          labelText: 'to',
                                          filled: true,
                                        )),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      get_report(_tocontroller.text,
                                          _fromcontroller.text);
                                    },
                                    child:
                                        Text(getTransrlate(context, 'Submit'))),
                              ],
                            );
                          },
                        );
                      }),
                ),
                Divider(),
                basic_report == null
                    ? Container()
                    : Container(
                        child: ResponsiveGridList(
                          rowMainAxisAlignment: MainAxisAlignment.center,
                          scroll: false,
                          desiredItemWidth: 120,
                          minSpacing: 10,
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Total Sale"),
                                    Text(
                                        "${basic_report.totalSale.roundToDouble()}",
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: themeColor.getColor())),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Total Invoices"),
                                    Text("${basic_report.totalInvoices}",
                                        style: TextStyle(
                                            color: themeColor.getColor())),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Total Customers"),
                                    Text("${basic_report.totalCustomers ?? 0}",
                                        style: TextStyle(
                                            color: themeColor.getColor())),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Total Orders"),
                                    Text("${basic_report.totalOrders}",
                                        style: TextStyle(
                                            color: themeColor.getColor())),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Total Vendors"),
                                    Text("${basic_report.totalVendors ?? 0}",
                                        style: TextStyle(
                                            color: themeColor.getColor())),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Total Products"),
                                    Text(
                                      "${basic_report.totalProducts}",
                                      style: TextStyle(
                                          color: themeColor.getColor()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: ScreenUtil.getHeight(context) / 2,
                    child: BarChart(
                      data: data,
                      labels: labels,
                      displayValue: true,
                      reverse: true,
                      getColor: DataRepository.getColor,
                      //getIcon: DataRepository.getIcon,
                      barWidth:
                          ScreenUtil.divideWidth(context) / (labels.length + 2),
                      barSeparation: 12,
                      animationDuration: Duration(milliseconds: 1800),
                      animationCurve: Curves.easeInOutSine,
                      itemRadius: 30,
                      headerValueHeight: 30,
                      roundValuesOnText: false,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _loadData() {
    setState(() {
      data =
          basic_report.periodDetails.map((e) => e.reports.totalSale).toList();
      labels = basic_report.periodDetails.map((e) => e.day).toList();
    });
  }

  void get_report(String to, String from) {
    API(context).post(
        'fetch/basic/report', {"from": "$from", "to": "$to"}).then((value) {
      if (value != null) {
        setState(() {
          basic_report = Basic_report.fromJson(value);
        });
        _loadData();
      }
    });
  }
}
