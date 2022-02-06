import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/bill_model.dart';
import 'package:trkar_vendor/screens/bills/add_bills.dart';
import 'package:trkar_vendor/screens/orderdetails.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/SerachLoading.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/Sort.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';
import 'package:trkar_vendor/widget/no_found_item.dart';
import 'package:trkar_vendor/widget/stores/Bills_item.dart';
import 'package:trkar_vendor/widget/stores/Invoice_item.dart';
import '../Invoicesdetails.dart';

class Bills extends StatefulWidget {
  @override
  _BillsState createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  List<Bill> invoices;
  String _character='ASC';

  final debouncer = Search(milliseconds: 1000);
  ScrollController _scrollController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String url="bills";
  int i = 2;
 
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
      }
    });
    getAllStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/invoices.svg',
              color: Colors.white,
              height: 25,
              width: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'bills')),
          ],
        ),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.search,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       builder: (_) => SearchOverlay(),
          //     );
          //   },
          // )
        ],
        backgroundColor: themeColor.getColor(),
      ),
      drawer: HiddenMenu(),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: FlatButton(
            color: Colors.blue,
            onPressed: () {
              Nav.route(context, Add_bills());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  Text(
                    getTransrlate(context, 'addBills'),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )),
      ) ,
      body: invoices == null
          ? Container(
          height: ScreenUtil.getHeight(context) / 3,
          child: Center(
              child: CircularProgressIndicator(
                valueColor:
                AlwaysStoppedAnimation<Color>(themeColor.getColor()),
              )))
          : invoices.isEmpty
          ? Center(
        child: NotFoundItem(title: '${getTransrlate(context, 'nofoundinvoices')}',),
      )
          : SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(
              height: 50,
              color: Colors.black12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('${invoices.length} ${getTransrlate(context, 'bills')}'),
                  SizedBox(
                    width: 100,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     // showDialog(
                  //     //     context: context,
                  //     //     builder: (_) => Filterdialog());
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Text('تصفية'),
                  //       Icon(
                  //         Icons.keyboard_arrow_down,
                  //         size: 20,
                  //       )
                  //     ],
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => Sortdialog()).then((val) {
                       setState(() {
                         _character=val;
                       });
                       url="packages?sort_type=${val??'DESC'}";
                    getAllStore();
                      });
                    },
                    child: Row(
                      children: [
                        Text('${getTransrlate(context, 'Sort')}'),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            ListView.builder(
              itemCount: invoices.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {

                  },
                  child: Container(
                    color: index.isOdd
                        ? Color(0xffF6F6F6)
                        : Colors.white,
                    child: BillsItem(
                      orders_model: invoices[index],
                      themeColor: themeColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getAllStore() async {
    i=2;
    API(context)
        .get(url)
        .then((value) {
      if (value != null) {
        setState(() {
          invoices = Bill_model.fromJson(value).data;
        });
      }
    });
  }

  Color isPassed(String value) {
    switch (value) {
      case 'inprogress':
        return Colors.amber;
        break;
      case 'pending':
        return Colors.green;
        break;
      case 'cancelled due to expiration':
        return Colors.deepPurpleAccent;
        break;
      case '5':
        return Colors.greenAccent;
      case 'cancelled':
        return Colors.red;
        break;
      default:
        return Colors.blue;
    }
  }



}
