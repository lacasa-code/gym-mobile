import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chart_components/bar_chart_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trkar_vendor/model/basic_report.dart';
import 'package:trkar_vendor/model/dashboard.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/screens/items/items.dart';
import 'package:trkar_vendor/screens/faq.dart';
import 'package:trkar_vendor/screens/packages/packages.dart';
import 'package:trkar_vendor/screens/message_show.dart';
import 'package:trkar_vendor/screens/product.dart';
import 'package:trkar_vendor/screens/productPage.dart';
import 'package:trkar_vendor/screens/tickets.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/data_repostory.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/screens/notification.dart';
import 'package:trkar_vendor/widget/custom_loading.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';

class HomeMobile extends StatefulWidget {
  @override
  _HomeMobileState createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<double> data = [50,40,30,20,10,5];
  List<String> labels = ['m1','m2','m3','m4','m5','m6',];
  bool loaded = false;
  List<Product> product;
  Dashboard basic_report = Dashboard();
  DateTime date = DateTime.now();
  DateTime from = DateTime.now().subtract(Duration(days: 7));
  TextEditingController _tocontroller = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController _fromcontroller = TextEditingController(
      text: DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: 7))));
  String name, roles;

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
    get_report(_tocontroller.text, _fromcontroller.text);
  }

  Future<void> _selectDateto(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context, initialDate: date, firstDate: from, lastDate: date);
    print("${DateFormat('yyyy-MM-dd').format(picked)}");

    if (picked != null)
      setState(() {
        _tocontroller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    get_report(_tocontroller.text, _fromcontroller.text);
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        name = prefs.getString('user_name');
        roles = prefs.getString("roles");
      });

      // get_report(DateFormat('yyyy-MM-dd').format(DateTime.now()),
      //     DateFormat('yyyy-MM-dd').format(DateTime.now()));
    });

    // API(context).get('vendor/about/rare/products').then((value) {
    //   if (value != null) {
    //     setState(() {
    //       product = Products_model.fromJson(value).product;
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeColor.getColor(),
      drawer: HiddenMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/ic_menu.svg',
                        color: Colors.white,
                        width: 50,
                        height: 50,
                      )),
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/trkar_logo_white.svg',
                      width: ScreenUtil.getWidth(context) / 5,
                    ),
                  ),
                  Container()
                ],
              ),
              Center(
                child: Container(

                  width: ScreenUtil.getWidth(context) / 1,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "${getTransrlate(context, 'welcome')}  ${name == null ? ' ' : name}",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                      Row(
                        children: [
                          AutoSizeText(
                            "Find Your ",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            " Report",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.black26)),
                        child: ResponsiveGridList(
                          scroll: false,
                          desiredItemWidth: ScreenUtil.getWidth(context) / 3,
                          minSpacing: 10,
                          children: [
                            CustomCard(() {
                              Nav.route(context, Items());
                            },
                                SvgPicture.asset(
                                  'assets/icons/Bell.svg',
                                  width: 18,
                                  height: 18,
                                  color: Colors.blue,
                                ),
                                "Active Customers",
                                Colors.blue,
                                "${basic_report.activeCustomers ?? '0'}",
                                themeColor),
                            CustomCard(() {
                              Nav.route(context, Items());
                            },
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                "Active Items",
                                Colors.green,
                                "${basic_report.activeItems ?? '0'}",
                                themeColor),
                            CustomCard(() {
                              Nav.route(context, Products());
                            },
                                Icon(
                                  Icons.person,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                "Customers",
                                Colors.red,
                                "${basic_report.activeCustomers ?? '0'}",
                                themeColor),
                            CustomCard(() {
                              Nav.route(context, Packages());
                            },
                                Icon(
                                  Icons.check_box_outline_blank,
                                  color: Colors.lightGreen,
                                  size: 18,
                                ),
                                "Count Customers",
                                Colors.lightGreen,
                                "${basic_report.countCustomers ?? '0'}",
                                themeColor),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      labels.isEmpty
                          ? Container()
                          : Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1, color: Colors.black26)),
                            height: ScreenUtil.getHeight(context) / 4,
                            child: BarChart(
                              data: data,
                              labels: labels,
                              labelStyle: TextStyle(fontSize: 12,color: Colors.white),
                              displayValue: true,
                              reverse: true,
                              getColor: DataRepository.getColor,
                              //getIcon: DataRepository.getIcon,
                              valueStyle: TextStyle(color: Colors.white),
                              barWidth: 45,
                              barSeparation: 5,
                              animationDuration:
                                  Duration(milliseconds: 5000),
                              animationCurve: Curves.easeInOutSine,
                              itemRadius: 1,
                              headerValueHeight: 30,
                              roundValuesOnText: false,
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
    );
  }

  void get_report(String to, String from) {
    API(context)
        .get('dashboard').then(
            (value) {
      if (value != null) {
        setState(() {
          basic_report = Dashboard_model.fromJson(value).data[0];
        });
      }
    });
  }

  CustomCard(GestureTapCallback ontap, Widget icon, String title, Color color,
      String value, Provider_control themeColor) {
    return value == "null"
        ? Container()
        : InkWell(
            onTap: ontap,
            child: Card(
              color: Colors.black,
              child: Container(
                width: ScreenUtil.getWidth(context) / 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      icon,
                      SizedBox(
                        width: 2,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: ScreenUtil.getWidth(context) /5,
                            child: AutoSizeText(
                              "$title",
                              minFontSize: 10,
                              maxLines: 1,
                              maxFontSize: 12,
                              style: TextStyle(
                                  color: color, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text("$value",
                              maxLines: 1,
                              style: TextStyle(color:Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
