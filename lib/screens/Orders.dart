import 'dart:async';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/orders_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/SerachLoading.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
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

  @override
  void initState() {
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
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            "assets/icons/ic_search.svg",
                            color: Colors.black45,
                            height: 12,
                          ),
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
                          return OrderItem(
                            orders_model: filteredStores[index],
                            themeColor: themeColor,
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  Future<void> getAllStore() async {
    API(context).get('show/orders').then((value) {
      if (value != null) {
        setState(() {
          filteredStores = stores = Orders_model.fromJson(value).data;
        });
      }
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
