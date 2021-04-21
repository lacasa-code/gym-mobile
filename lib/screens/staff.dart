import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/user_model.dart';
import 'package:trkar_vendor/screens/add_staff.dart';
import 'package:trkar_vendor/screens/edit_staff.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/SerachLoading.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/stores/user_item.dart';

class Staff extends StatefulWidget {
  @override
  _StaffState createState() => _StaffState();
}

class _StaffState extends State<Staff> {
  List<User> stores;
  List<User> filteredStores;
  final debouncer = Search(milliseconds: 1000);
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<User>> key = new GlobalKey();

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
        title: Text(getTransrlate(context, 'staff')),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
            child: InkWell(
                onTap: () {
                  _navigate_add_hell(context);
                },
                child: Text(getTransrlate(context, 'addstaff'))),
          )
        ],
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
                          'no users found ',
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
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(bottom: 4),
                              height: 72,
                              child: searchTextField =
                                  AutoCompleteTextField<User>(
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
                                  return item.name
                                      .toLowerCase()
                                      .startsWith(query.toLowerCase());
                                },
                                itemSorter: (a, b) {
                                  return a.name.compareTo(b.name);
                                },
                                itemSubmitted: (item) {
                                  setState(() {
                                    searchTextField.textField.controller.text =
                                        item.name;
                                  });
                                  debouncer.run(() {
                                    setState(() {
                                      filteredStores = stores
                                          .where((u) =>
                                              (u.name.toLowerCase().contains(
                                                  searchTextField
                                                      .textField.controller.text
                                                      .toLowerCase())) ||
                                              (u.email.toLowerCase().contains(
                                                  searchTextField
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
                                              (u.name.toLowerCase().contains(
                                                  string.toLowerCase())) ||
                                              (u.email.toLowerCase().contains(
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
                          return Row(
                            children: [
                              User_item(
                                hall_model: filteredStores[index],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _navigate_edit_hell(
                                          context, filteredStores[index]);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      margin: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(.2),
                                              blurRadius:
                                                  6.0, // soften the shadow
                                              spreadRadius:
                                                  0.0, //extend the shadow
                                              offset: Offset(
                                                0.0, // Move to right 10  horizontally
                                                1.0, // Move to bottom 10 Vertically
                                              ),
                                            )
                                          ]),
                                      width: ScreenUtil.getWidth(context) / 4,
                                      child: Center(
                                        child: AutoSizeText(
                                          'Edit',
                                          minFontSize: 10,
                                          maxFontSize: 20,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      API(context)
                                          .Delete("users/${stores[index].id}")
                                          .then((value) {
                                        if (value != null) {
                                          showDialog(
                                            context: context,
                                            builder: (_) => ResultOverlay(
                                              value.containsKey('errors')
                                                  ? "${value['errors']}"
                                                  : 'تم حذف العامل بنجاح',
                                            ),
                                          );
                                        }
                                        getAllStore();
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      margin: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(.2),
                                              blurRadius:
                                                  6.0, // soften the shadow
                                              spreadRadius:
                                                  0.0, //extend the shadow
                                              offset: Offset(
                                                0.0, // Move to right 10  horizontally
                                                1.0, // Move to bottom 10 Vertically
                                              ),
                                            )
                                          ]),
                                      width: ScreenUtil.getWidth(context) / 4,
                                      child: Center(
                                        child: AutoSizeText(
                                          'Delete',
                                          minFontSize: 10,
                                          maxFontSize: 20,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
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

  _navigate_add_hell(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => add_Staff()));
    Timer(Duration(seconds: 3), () => getAllStore());
  }

  _navigate_edit_hell(BuildContext context, User hall) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Edit_Staff(hall)));
    Timer(Duration(seconds: 3), () => getAllStore());
  }

  Future<void> getAllStore() async {
    API(context).get('users').then((value) {
      if (value != null) {
        setState(() {
          filteredStores = stores = User_model.fromJson(value).data;
        });
      }
    });
  }

  Widget row(User productModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          productModel.name,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          productModel.email,
        ),
      ],
    );
  }
}