import 'dart:async';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/orders_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/SerachLoading.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/stores/Order_item.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order> stores;
  List<Order> filteredStores;
  final debouncer = Search(milliseconds: 1000);
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Order>> key = new GlobalKey();
  ScrollController _scrollController = new ScrollController();
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
      appBar: AppBar(
        title: Text("Orders"),
        centerTitle: true,
        backgroundColor: themeColor.getColor(),
      ),
      body: stores == null
          ? Container(
              height: ScreenUtil.getHeight(context) / 3,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(themeColor.getColor()),
              )))
          : stores.isEmpty
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
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(bottom: 4),
                              height: 72,
                              child: searchTextField =
                                  AutoCompleteTextField<Order>(
                                key: key,
                                clearOnSubmit: false,
                                suggestions: filteredStores,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: getTransrlate(context, 'search'),
                                    hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF5D6A78),
                                      fontWeight: FontWeight.w400,
                                    )),
                                itemFilter: (item, query) {
                                  return item.orderNumber
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(query.toLowerCase());
                                },
                                itemSorter: (a, b) {
                                  return a.orderNumber.compareTo(b.orderNumber);
                                },
                                itemSubmitted: (item) {
                                  setState(() {
                                    searchTextField.textField.controller.text =
                                        item.orderNumber.toString();
                                  });
                                  debouncer.run(() {
                                    setState(() {
                                      filteredStores = stores
                                          .where((u) =>
                                              (u.orderNumber
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(searchTextField
                                                      .textField.controller.text
                                                      .toLowerCase())) ||
                                              (u.orderTotal
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(searchTextField
                                                      .textField.controller.text
                                                      .toLowerCase())))
                                          .toList();
                                    });
                                  });
                                },
                                textChanged: (string) {
                                  debouncer.run(() {
                                    setState(() {
                                      filteredStores = stores
                                          .where((u) =>
                                              (u.orderNumber
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                      string.toLowerCase())) ||
                                              (u.orderTotal
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                      string.toLowerCase())))
                                          .toList();
                                    });
                                  });
                                },
                                itemBuilder: (context, item) {
                                  // ui for the autocompelete row
                                  return row(item);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        itemCount: filteredStores == null && stores.isEmpty
                            ? 0
                            : filteredStores.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              OrderItem(
                                orders_model: filteredStores[index],
                                themeColor: themeColor,
                              ),
                              filteredStores[index].orderStatus != 'pending'
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        FlatButton(
                                          color: Colors.green,
                                          padding: EdgeInsets.all(4),
                                          onPressed: () {
                                            API(context).post(
                                                'vendor/approve/orders', {
                                              "status": "1",
                                              "order_id":
                                                  filteredStores[index].id
                                            }).then((value) {
                                              if (value != null) {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => ResultOverlay(
                                                    value.containsKey('message')
                                                        ? value['message']
                                                        : 'Done',
                                                  ),
                                                );
                                                getAllStore();
                                              }
                                            });
                                          },
                                          child: Text(
                                            'Accept',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        FlatButton(
                                          color: Colors.red,
                                          padding: EdgeInsets.all(4),
                                          onPressed: () {
                                            API(context).post(
                                                'vendor/cancel/order', {
                                              "order_id":
                                                  filteredStores[index].id
                                            }).then((value) {
                                              if (value != null) {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => ResultOverlay(
                                                    value.containsKey('message')
                                                        ? value['message']
                                                        : 'Done',
                                                  ),
                                                );
                                              }
                                              getAllStore();
                                            });
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  Future<void> getAllStore() async {
    // ordered_by   >>> created_at
    // sort_type  >>> desc
    API(context)
        .get('show/orders?ordered_by=created_at&sort_type=desc')
        .then((value) {
      if (value != null) {
        setState(() {
          filteredStores = stores = Orders_model.fromJson(value).data;
        });
      }
    });
  }

  void pageFetch() {
    API(context)
        .get('show/orders?page=${i++}&ordered_by=created_at&sort_type=desc')
        .then((value) {
      setState(() {
        stores.addAll(Orders_model.fromJson(value).data);
        filteredStores.addAll(Orders_model.fromJson(value).data);
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
