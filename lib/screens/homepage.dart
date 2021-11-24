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
import 'package:trkar_vendor/screens/Orders.dart';
import 'package:trkar_vendor/screens/faq.dart';
import 'package:trkar_vendor/screens/invoices.dart';
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
  List<double> data = [];
  List<String> labels = [];
  bool loaded = false;
  List<Product> product;
  Basic_report basic_report;
  DateTime date = DateTime.now();
  DateTime from = DateTime.now().subtract(Duration(days: 7));
  TextEditingController _tocontroller = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController _fromcontroller = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7))));
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

      get_report(DateFormat('yyyy-MM-dd').format(DateTime.now()),
          DateFormat('yyyy-MM-dd').format(DateTime.now()));
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
              // SizedBox(
              //   height: 5,
              // ),
              // AutoSizeText(
              //   "${getTransrlate(context, 'welcome')}  ${name == null ? ' ' : name}",
              //   style: TextStyle(
              //       fontSize: 14,
              //       color: Colors.black,
              //       fontWeight: FontWeight.bold),
              // ),
              SizedBox(
                height: 20,
              ),
              basic_report == null
                  ? Container(
                      child: Center(
                          child: Custom_Loading()),
                    )
                  : Container(
                      color: Color(0xffF6F6F6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: [
                          //     Container(
                          //         width: ScreenUtil.getWidth(context) / 6,
                          //         child: Text(
                          //             '${getTransrlate(context, 'duration')} : ',style: TextStyle(fontSize: 12),)),
                          //     InkWell(
                          //       onTap: () {
                          //         _selectDatefrom(context);
                          //       },
                          //       child: Row(
                          //         children: [
                          //           Icon(
                          //             Icons.calendar_today_outlined,
                          //             color: Colors.black26,
                          //           ),
                          //           SizedBox(
                          //             width: 5,
                          //           ),
                          //           Container(
                          //               width:
                          //                   ScreenUtil.getWidth(context) / 3.2,
                          //               child: Text(
                          //                 " ${getTransrlate(context, 'from')} : ${_fromcontroller.text}",
                          //                 style: TextStyle(fontSize: 12),
                          //               )),
                          //         ],
                          //       ),
                          //     ),
                          //     InkWell(
                          //       onTap: () {
                          //         _selectDateto(context);
                          //       },
                          //       child: Row(
                          //         children: [
                          //           Icon(
                          //             Icons.calendar_today_outlined,
                          //             color: Colors.black26,
                          //           ),
                          //           SizedBox(
                          //             width: 5,
                          //           ),
                          //           Container(
                          //               width:
                          //                   ScreenUtil.getWidth(context) / 3.2,
                          //               child: Text(
                          //                   " ${getTransrlate(context, 'to')} : ${_tocontroller.text}",
                          //                   style: TextStyle(fontSize: 12))),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Divider(),
                          if (basic_report == null)
                            Container()
                          else
                            Container(
                              child: ResponsiveGridList(
                                scroll: false,
                                desiredItemWidth: ScreenUtil.getWidth(context) / 1.5,
                                minSpacing: 10,
                                children: [
                                  CustomCard(() {
                                    Nav.route(context, Orders());
                                  },
                                      SvgPicture.asset(
                                        'assets/icons/Bell.svg',
                                        width: 18,
                                        height: 18,
                                        color: Colors.blue,
                                      ),
                                      "Transactions",
                                      Colors.blue,
                                      "${basic_report.totalOrders}",
                                      themeColor),
                                  CustomCard(() {
                                    Nav.route(context, Orders());
                                  },
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                      "Packages",
                                      Colors.green,
                                      "${basic_report.pending_orders}",
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
                                      "${basic_report.totalProducts}",
                                      themeColor),
                                  CustomCard(() {
                                    Nav.route(context, Invoices());
                                  },
                                      Icon(
                                        Icons.check_box_outline_blank,
                                        color: Colors.lightGreen,
                                        size: 18,
                                      ),
                                      "Items",
                                      Colors.lightGreen,
                                      "${basic_report.totalSale}",
                                      themeColor),
                                  InkWell(
                                    onTap: () {
                                      Nav.route(context, FaqPage());
                                    },
                                    child: Card(
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
                                              color: Colors.yellow,
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: ScreenUtil.getWidth(
                                                          context) /
                                                      3.1,
                                                  child: AutoSizeText(
                                                    "Overdue Bills",
                                                    minFontSize: 10,
                                                    maxLines: 1,
                                                    maxFontSize: 15,
                                                    style: TextStyle(
                                                        color: Colors.yellow,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Text(
                                                    "${basic_report.prod_questions ?? '0'}",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: Colors.yellow)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     Nav.route(context, Tickets());
                                  //   },
                                  //   child: Card(
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(8.0),
                                  //       child: Row(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: [
                                  //           Icon(
                                  //             Icons.error_outline,
                                  //             color: Colors.red,
                                  //             size: 18,
                                  //           ),
                                  //           SizedBox(
                                  //             width: 3,
                                  //           ),
                                  //           Column(
                                  //             crossAxisAlignment:
                                  //                 CrossAxisAlignment.start,
                                  //             children: [
                                  //               Container(
                                  //                 width: ScreenUtil.getWidth(
                                  //                         context) /
                                  //                     3.1,
                                  //                 child: AutoSizeText(
                                  //                   "${getTransrlate(context, 'tickets')}",
                                  //                   minFontSize: 13,
                                  //                   maxLines: 1,
                                  //                   maxFontSize: 14,
                                  //                   style: TextStyle(
                                  //                       color: Colors.red,
                                  //                       fontWeight:
                                  //                           FontWeight.bold),
                                  //                 ),
                                  //               ),
                                  //               Text(
                                  //                   "${basic_report.tickets ?? '0'}",
                                  //                   maxLines: 1,
                                  //                   style: TextStyle(
                                  //                       color: themeColor
                                  //                           .getColor())),
                                  //             ],
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
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
                                      labelStyle: TextStyle(fontSize: 12),
                                      displayValue: true,
                                      reverse: true,
                                      getColor: DataRepository.getColor,
                                      //getIcon: DataRepository.getIcon,
                                      barWidth:100,
                                      barSeparation: 5,
                                      animationDuration:
                                          Duration(milliseconds: 5000),
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
              // product == null
              //     ? Container()
              //     : product.isEmpty
              //         ? Container()
              //         : Card(
              //             child: Container(
              //               decoration: BoxDecoration(
              //                   border: Border.all(color: Colors.black12)),
              //               padding: const EdgeInsets.all(12.0),
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Padding(
              //                     padding: const EdgeInsets.all(8.0),
              //                     child: Row(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         Container(
              //                           width: ScreenUtil.getWidth(context) / 2,
              //                           child: AutoSizeText(
              //                             "${getTransrlate(context, 'Inventoryplay')}",
              //                             maxLines: 2,
              //                             style: TextStyle(
              //                               fontSize: 12,
              //                               fontWeight: FontWeight.bold,
              //                             ),
              //                             minFontSize: 11,
              //                           ),
              //                         ),
              //                         Expanded(
              //                           child: SizedBox(
              //                             width: 10,
              //                           ),
              //                         ),
              //                         Text(
              //                           "${getTransrlate(context, 'residual')}",
              //                           style: TextStyle(color: Colors.black,fontSize: 12),
              //                         )
              //                       ],
              //                     ),
              //                   ),
              //                   ListView.builder(
              //                     padding: EdgeInsets.all(1),
              //                     primary: false,
              //                     shrinkWrap: true,
              //                     physics: NeverScrollableScrollPhysics(),
              //                     itemCount: product.length,
              //                     itemBuilder:
              //                         (BuildContext context, int index) {
              //                       return InkWell(
              //                         onTap: () {
              //                           Nav.route(
              //                               context,
              //                               ProductPage(
              //                                   product: product[index]));
              //                         },
              //                         child: Column(
              //                           children: [
              //                             Row(
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.center,
              //                               children: [
              //                                 Container(
              //                                   width: ScreenUtil.getWidth(
              //                                           context) /
              //                                       8,
              //                                   height: ScreenUtil.getWidth(
              //                                           context) /
              //                                       8,
              //                                   child: CachedNetworkImage(
              //                                     imageUrl: product[index]
              //                                             .photo
              //                                             .isNotEmpty
              //                                         ? product[index]
              //                                             .photo[0]
              //                                             .image
              //                                         : '',
              //                                     errorWidget:
              //                                         (context, url, error) =>
              //                                             Icon(
              //                                       Icons.image,
              //                                       color: Colors.black12,
              //                                     ),
              //                                     fit: BoxFit.contain,
              //                                   ),
              //                                 ),
              //                                 SizedBox(
              //                                   width: 10,
              //                                 ),
              //                                 Container(
              //                                   width: ScreenUtil.getWidth(
              //                                           context) /
              //                                       2,
              //                                   child: AutoSizeText(
              //                                     "${themeColor.getlocal() == 'ar' ? product[index].name ?? product[index].nameEn : product[index].nameEn ?? product[index].name}",
              //                                     maxLines: 2,
              //                                     style: TextStyle(
              //                                       fontSize: 14,
              //                                       fontWeight: FontWeight.bold,
              //                                     ),
              //                                     minFontSize: 13,
              //                                   ),
              //                                 ),
              //                                 Expanded(
              //                                   child: SizedBox(
              //                                     width: 10,
              //                                   ),
              //                                 ),
              //                                 Text(
              //                                   "${product[index].quantity}",
              //                                   style: TextStyle(
              //                                       color: Colors.red),
              //                                 ),
              //                                 SizedBox(
              //                                   width: 20,
              //                                 )
              //                               ],
              //                             ),
              //                             Container(
              //                               height: 1,
              //                               color: Colors.black12,
              //                             )
              //                           ],
              //                         ),
              //                       );
              //                     },
              //                   ),
              //                   Container(
              //                     height: 1,
              //                     color: Colors.black12,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           )
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
      labels =
          basic_report.periodDetails.map((e) => e.dayName ?? e.day).toList();
    });
  }
  void get_report(String to, String from) {
    API(context)
        .post('vendor/day/month/filter', {"from": "$from", "to": "$to"}).then(
            (value) {
      print("value =$value");
      if (value != null) {
        setState(() {
          basic_report = Basic_report.fromJson(value);
        });
        roles=='Staff'?null:_loadData();
      }
    });
  }
  CustomCard(GestureTapCallback ontap, Widget icon, String title, Color color,
      String value, Provider_control themeColor) {
    return value=="null"?Container(): InkWell(
      onTap:ontap,
      child: Card(
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
                    width: ScreenUtil.getWidth(context) / 3.2,
                    child: AutoSizeText(
                      "$title",
                      minFontSize: 10,
                      maxLines: 1,
                      maxFontSize: 12,
                      style:
                          TextStyle(color: color, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text("$value",
                      maxLines: 1,
                      style: TextStyle(color: themeColor.getColor())),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
