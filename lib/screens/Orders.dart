import 'dart:async';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
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
import 'package:trkar_vendor/widget/Sort.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';
import 'package:trkar_vendor/widget/stores/Order_item.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order> orders;
  List<Order> filteredOrders;
  final debouncer = Search(milliseconds: 1000);
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Order>> key = new GlobalKey();
  ScrollController _scrollController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int i = 2;

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
            Text(getTransrlate(context, 'Myorders')),
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
                builder: (_) => SearchOverlay(),
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
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Icon(Icons.check_box_outline_blank_sharp),
                        SizedBox(height: 20),
                        Text(
                          'no Orders found ',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
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
                            Text('${orders.length} طلبات'),
                            SizedBox(
                              width: 100,
                            ),
                            InkWell(
                              onTap: () {
                                // showDialog(
                                //     context: context,
                                //     builder: (_) => Filterdialog());
                              },
                              child: Row(
                                children: [
                                  Text('تصفية'),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => Sortdialog()).then((val) {
                                  print(val);
                                  API(context)
                                      .get('users?sort_type=${val}')
                                      .then((value) {
                                    if (value != null) {
                                      if (value['status_code'] == 200) {
                                        setState(() {
                                          filteredOrders = orders =
                                              Orders_model.fromJson(value).data;
                                        });
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (_) => ResultOverlay(
                                                value['message']));
                                      }
                                    }
                                  });
                                });
                              },
                              child: Row(
                                children: [
                                  Text('ترتيب'),
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
                        itemCount: filteredOrders == null && orders.isEmpty
                            ? 0
                            : filteredOrders.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Nav.route(
                                  context,
                                  Order_information(
                                    orders: filteredOrders,
                                    orders_model: filteredOrders[index],
                                  ));
                            },
                            child: Container(
                              color: index.isOdd
                                  ? Color(0xffF6F6F6)
                                  : Colors.white,
                              child: Column(
                                children: [
                                  OrderItem(
                                    orders_model: filteredOrders[index],
                                    themeColor: themeColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 40, left: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          ' ${getTransrlate(context, 'totalOrder')} : ${filteredOrders[index].orderTotal} ${getTransrlate(context, 'Currency')} ',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        filteredOrders[index].orderStatus !=
                                                'pending'
                                            ? Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      getTransrlate(context,
                                                          'OrderState'),
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      width: 80,
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: isPassed(
                                                                  filteredOrders[
                                                                          index]
                                                                      .orderStatus
                                                                      .toString()))),
                                                      child: Center(
                                                        child: Text(
                                                          '${filteredOrders[index].orderStatus}',
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: isPassed(
                                                                filteredOrders[
                                                                        index]
                                                                    .orderStatus
                                                                    .toString()),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  FlatButton(
                                                    padding: EdgeInsets.all(4),
                                                    onPressed: () {
                                                      API(context).post(
                                                          'vendor/approve/orders',
                                                          {
                                                            "status": "1",
                                                            "order_id":
                                                                filteredOrders[
                                                                        index]
                                                                    .id
                                                          }).then((value) {
                                                        if (value != null) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (_) =>
                                                                ResultOverlay(
                                                              value.containsKey(
                                                                      'message')
                                                                  ? value[
                                                                      'message']
                                                                  : 'Done',
                                                            ),
                                                          );
                                                          getAllStore();
                                                        }
                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            color: Colors
                                                                .lightGreen),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          'قبول',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .lightGreen,
                                                              fontSize: 15,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  FlatButton(
                                                    padding: EdgeInsets.all(4),
                                                    onPressed: () {
                                                      API(context).post(
                                                          'vendor/cancel/order',
                                                          {
                                                            "order_id":
                                                                filteredOrders[
                                                                        index]
                                                                    .id
                                                          }).then((value) {
                                                        if (value != null) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (_) =>
                                                                ResultOverlay(
                                                              value.containsKey(
                                                                      'message')
                                                                  ? value[
                                                                      'message']
                                                                  : 'Done',
                                                            ),
                                                          );
                                                        }
                                                        getAllStore();
                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                            CupertinoIcons
                                                                .clear_circled,
                                                            size: 25,
                                                            color: Colors.red),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          'رفض',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 15,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 1,
                                    color: Colors.black12,
                                  )
                                ],
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
    API(context)
        .get('show/orders?ordered_by=created_at&sort_type=desc')
        .then((value) {
      if (value != null) {
        setState(() {
          filteredOrders = orders = Orders_model.fromJson(value).data;
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
    API(context)
        .get('show/orders?page=${i++}&ordered_by=created_at&sort_type=desc')
        .then((value) {
      setState(() {
        orders.addAll(Orders_model.fromJson(value).data);
        filteredOrders.addAll(Orders_model.fromJson(value).data);
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
