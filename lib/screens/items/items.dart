import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/item_model.dart';
import 'package:trkar_vendor/model/orders_model.dart';
import 'package:trkar_vendor/screens/orderdetails.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/SerachLoading.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay_order.dart';
import 'package:trkar_vendor/widget/Sort.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';
import 'package:trkar_vendor/widget/no_found_item.dart';
import 'package:trkar_vendor/widget/stores/Order_item.dart';

class Items extends StatefulWidget {
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  List<Item> orders;
  final debouncer = Search(milliseconds: 1000);
  ScrollController _scrollController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String url = "items";
  int i = 2;
bool Cloading=false;
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        pageFetch();
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
              'assets/icons/orders.svg',
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'items')),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => SearchOverlay_Order(
                  url: 'orders/search/name',
                ),
              );
            },
          )
        ],
        backgroundColor: themeColor.getColor(),
      ),
      drawer: HiddenMenu(),
      body: orders == null
          ? Container(
              height: ScreenUtil.getHeight(context) / 3,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(themeColor.getColor()),
              )))
          : orders.isEmpty
              ? Center(
                  child: Container(
                    child: NotFoundItem(
                      title: '${getTransrlate(context, 'NoOrder')}',
                    ),
                  ),
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
                            Text(
                                '${orders.length} ${getTransrlate(context, 'items')}'),
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
                                  print(val);
                                  url='show/orders?sort_type=${val??'ASC'}';
                                  getAllStore();
                                  // API(context).post(
                                  //     '$url?ordered_by=created_at&sort_type=${val ?? 'ASC'}',
                                  //     {}).then((value) {
                                  //   if (value != null) {
                                  //     if (value['status_code'] == 200) {
                                  //       setState(() {
                                  //         orders = orders =
                                  //             Orders_model.fromJson(value).data;
                                  //       });
                                  //     } else {
                                  //       showDialog(
                                  //           context: context,
                                  //           builder: (_) =>
                                  //               ResultOverlay(value['errors']));
                                  //     }
                                  //   }
                                  // });
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
                        itemCount: orders.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color: index.isOdd
                                ? Color(0xffF6F6F6)
                                : Colors.white,
                            child: Column(
                              children: [
                                Item_item(
                                  orders_model: orders[index],
                                  themeColor: themeColor,
                                ),
                              ],
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
        .get('${url}').then((value) {
      if (value != null) {
        print(value);
        setState(() {
           orders = Item_model.fromJson(value).data;
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

  void pageFetch() {
    API(context).post(
        '$url${url.contains('?')?'&':'?'}page=${i++}',
        {}).then((value) {
      print(value);
      setState(() {
        orders.addAll(Item_model.fromJson(value).data);
      });
    });
  }

  Widget row(Order productModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          productModel.orderNumber.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          productModel.orderTotal.toString(),
        ),
      ],
    );
  }
}
