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
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/screens/message_show.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/data_repostory.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/screens/notification.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';

class HomeMobile extends StatefulWidget {
  @override
  _HomeMobileState createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<double> data = [];
  List<String> labels = [];
  bool loaded = false;
  List<Product> product;
  Basic_report basic_report;
  DateTime date = DateTime.now();
  DateTime from = DateTime.now();
  TextEditingController _tocontroller = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController _fromcontroller = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  String name;

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
    get_report(DateFormat('yyyy-MM-dd').format(DateTime.now()),
        DateFormat('yyyy-MM-dd').format(DateTime.now()));
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        name = prefs.getString('user_name');
      });
    });
    API(context).get('vendor/about/rare/products').then((value) {
      if (value != null) {
        setState(() {
          product = Products_model.fromJson(value).product;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: HiddenMenu(),
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          width: ScreenUtil.getWidth(context) / 4,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Nav.route(context, Message_show());
              },
              icon: Icon(Icons.messenger_outline)),
          IconButton(
              onPressed: () {
                Nav.route(context, Notification_show());
              },
              icon: Icon(Icons.notifications_none)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              AutoSizeText(
                "${getTransrlate(context, 'welcome')}  ${name == null ? ' ' : name}",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Color(0xffF6F6F6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: ScreenUtil.getWidth(context) / 6,
                            child: Text(
                                '${getTransrlate(context, 'duration')} : ')),
                        InkWell(
                          onTap: () {
                            _selectDatefrom(context);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black26,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  width: ScreenUtil.getWidth(context) / 3.2,
                                  child: Text(
                                    " ${getTransrlate(context, 'from')} : ${_fromcontroller.text}",
                                    style: TextStyle(fontSize: 14),
                                  )),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _selectDateto(context);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black26,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  width: ScreenUtil.getWidth(context) / 3.2,
                                  child: Text(
                                      " ${getTransrlate(context, 'to')} : ${_tocontroller.text}",
                                      style: TextStyle(fontSize: 14))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    basic_report == null
                        ? Container()
                        : Container(
                            child: ResponsiveGridList(
                              scroll: false,
                              desiredItemWidth:
                                  ScreenUtil.getWidth(context) / 2.3,
                              minSpacing: 10,
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/Bell.svg',
                                          width: 18,
                                          height: 18,
                                          color: Colors.green,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width:
                                                  ScreenUtil.getWidth(context) /
                                                      3.1,
                                              child: AutoSizeText(
                                                "${getTransrlate(context, 'total_orders')}",
                                                minFontSize: 13,
                                                maxLines: 1,
                                                maxFontSize: 14,
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Text("${basic_report.totalOrders}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color:
                                                        themeColor.getColor())),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.local_shipping_outlined,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${getTransrlate(context, 'pending_orders')}",
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "${basic_report.pending_orders}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color:
                                                        themeColor.getColor())),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.money,
                                          color: Colors.lightGreen,
                                          size: 18,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width:
                                                  ScreenUtil.getWidth(context) /
                                                      3.1,
                                              child: AutoSizeText(
                                                "${getTransrlate(context, 'total_sale')}",
                                                minFontSize: 13,
                                                maxLines: 1,
                                                maxFontSize: 14,
                                                style: TextStyle(
                                                    color: Colors.lightGreen,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Text("${basic_report.totalSale}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color:
                                                        themeColor.getColor())),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.shopping_bag_outlined,
                                          color: Colors.brown,
                                          size: 18,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width:
                                                  ScreenUtil.getWidth(context) /
                                                      3.1,
                                              child: AutoSizeText(
                                                "${getTransrlate(context, 'total_products')}",
                                                minFontSize: 13,
                                                maxLines: 1,
                                                maxFontSize: 14,
                                                style: TextStyle(
                                                    color: Colors.brown,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Text(
                                                "${basic_report.totalProducts.roundToDouble()}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color:
                                                        themeColor.getColor())),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/Question mark.svg',
                                          width: 18,
                                          height: 18,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width:
                                                  ScreenUtil.getWidth(context) /
                                                      3.1,
                                              child: AutoSizeText(
                                                "${getTransrlate(context, 'prod_questions')}",
                                                minFontSize: 10,
                                                maxLines: 1,
                                                maxFontSize: 15,
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Text(
                                                "${basic_report.prod_questions ?? '0'}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color:
                                                        themeColor.getColor())),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width:
                                                  ScreenUtil.getWidth(context) /
                                                      3.1,
                                              child: AutoSizeText(
                                                "${getTransrlate(context, 'tickets')}",
                                                minFontSize: 13,
                                                maxLines: 1,
                                                maxFontSize: 14,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Text(
                                                "${basic_report.tickets ?? '0'}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color:
                                                        themeColor.getColor())),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    labels.isEmpty
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: ScreenUtil.getHeight(context) / 4,
                              child: BarChart(
                                data: data,
                                labels: labels,
                                displayValue: true,
                                reverse: true,
                                getColor: DataRepository.getColor,
                                //getIcon: DataRepository.getIcon,
                                barWidth: ScreenUtil.divideWidth(context) / 5,
                                barSeparation: 5,
                                animationDuration: Duration(milliseconds: 5000),
                                animationCurve: Curves.easeInOutSine,
                                itemRadius: 1,
                                headerValueHeight: 30,
                                roundValuesOnText: false,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              product == null
                  ? Container()
                  : product.isEmpty
                      ? Container()
                      : Card(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12)),
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: ScreenUtil.getWidth(context) / 2,
                                        child: AutoSizeText(
                                          "${getTransrlate(context, 'Inventoryplay')}",
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          minFontSize: 11,
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: 10,
                                        ),
                                      ),
                                      Text(
                                        "${getTransrlate(context, 'residual')}",
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  padding: EdgeInsets.all(1),
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: product.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width:
                                                  ScreenUtil.getWidth(context) /
                                                      8,
                                              height:
                                                  ScreenUtil.getWidth(context) /
                                                      8,
                                              child: CachedNetworkImage(
                                                imageUrl: product[index]
                                                        .photo
                                                        .isNotEmpty
                                                    ? product[index]
                                                        .photo[0]
                                                        .image
                                                    : '',
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(
                                                  Icons.image,
                                                  color: Colors.black12,
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width:
                                                  ScreenUtil.getWidth(context) /
                                                      2,
                                              child: AutoSizeText(
                                                product[index].name,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                minFontSize: 11,
                                              ),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: 10,
                                              ),
                                            ),
                                            Text(
                                              "${product[index].quantity}",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 1,
                                          color: Colors.black12,
                                        )
                                      ],
                                    );
                                  },
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }

  void _loadData() {
    setState(() {
      data =
          basic_report.periodDetails.map((e) => e.reports.totalSale).toList();
      labels = basic_report.periodDetails.map((e) => e.dayName).toList();
    });
  }

  void get_report(String to, String from) {
    API(context)
        .post('vendor/day/month/filter', {"from": "$from", "to": "$to"}).then(
            (value) {
      if (value != null) {
        setState(() {
          basic_report = Basic_report.fromJson(value);
        });
        _loadData();
      }
    });
  }
}
