import 'package:chart_components/bar_chart_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:trkar_vendor/model/basic_report.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/data_repostory.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/commons/default_button.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<double> data = [];
  List<String> labels = [];
  bool loaded = false;
  Basic_report basic_report;
  DateTime date = DateTime.now();
  TextEditingController _tocontroller = TextEditingController();
  TextEditingController _fromcontroller = TextEditingController();
  Future<void> _selectDatefrom(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: date);
    if (picked != null && picked != date)
      setState(() {
        _fromcontroller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  Future<void> _selectDateto(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: date);
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

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
                  color: themeColor.getColor(),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35, bottom: 35),
                    child: Image.asset(
                      'assets/images/logo.png',
                      color: themeColor.getColor(),
                      height: ScreenUtil.getHeight(context) / 10,
                      width: ScreenUtil.getWidth(context) / 2,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 10,
                ),
              ],
            ),
            Text(DateFormat('yyyy-MM-dd').format(DateTime.now())),
            Container(
              width: ScreenUtil.getWidth(context) / 3,
              child: DefaultButton(
                  text: getTransrlate(context, 'filter'),
                  press: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext contex) {
                        return AlertDialog(
                          title: Text('Filter Sales by period'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 10),
                              TextFormField(
                                  readOnly: true,
                                  onTap: () => _selectDatefrom(context),
                                  controller: _fromcontroller,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.calendar_today),
                                    hintText: 'date',
                                    contentPadding: EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    fillColor: Color(0xFFEEEEF3),
                                    labelText: 'from',
                                    filled: true,
                                  )),
                              SizedBox(height: 10),
                              TextFormField(
                                  readOnly: true,
                                  onTap: () => _selectDateto(context),
                                  controller: _tocontroller,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.calendar_today),
                                    hintText: 'date',
                                    contentPadding: EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
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
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  get_report(
                                      _tocontroller.text, _fromcontroller.text);
                                },
                                child: Text(getTransrlate(context, 'Submit'))),
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
                                Text("${basic_report.totalSale}",
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
                                  style:
                                      TextStyle(color: themeColor.getColor()),
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
