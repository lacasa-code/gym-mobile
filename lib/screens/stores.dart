import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/screens/add_store.dart';
import 'package:trkar_vendor/screens/edit_store.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/SerachLoading.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay_Store.dart';
import 'package:trkar_vendor/widget/Sort.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';
import 'package:trkar_vendor/widget/stores/store_item.dart';

class Stores extends StatefulWidget {
  @override
  _StoresState createState() => _StoresState();
}

class _StoresState extends State<Stores> {

  List<int> selectStores = [];
  String url="stores";
  int i = 2;
  ScrollController _scrollController = new ScrollController();

  final debouncer = Search(milliseconds: 1000);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isSelect = false;

  @override
  void initState() {
    Provider.of<Provider_Data>(context,listen: false).getAllStore(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<Provider_Data>(context,listen: false).PerStore(context);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    final Data = Provider.of<Provider_Data>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: HiddenMenu(),
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
              'assets/icons/store.svg',
              color: Colors.white,
              height: 25,
              width: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'stores')),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: (){
              showDialog(
                context: context,
                builder: (_) => SearchOverlay_Store(url: 'stores/search/name',),
              );},
          )
        ],
        backgroundColor: themeColor.getColor(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FlatButton(
              color: Colors.orange,
              onPressed: () {
               Nav.route(context, add_Store());
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
                      getTransrlate(context, 'addStore'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )),
        ),
      ),
      body: Data.stores == null
          ? Container(
              height: ScreenUtil.getHeight(context) / 3,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(themeColor.getColor()),
              )))
          : Data.stores.isEmpty
              ? Center(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Icon(Icons.hourglass_empty_outlined,size: 100,color: Colors.black26,),
                        SizedBox(height: 20),
                        Text(
                          'no stores found ',
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
                      isSelect
                          ? Container(
                        height: 50,
                        color: Colors.black12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Text('تم اختيار '),
                                Text('( ${selectStores.length} )'),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isSelect = true;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Colors.black45,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('اختر الكل')
                                ],
                              ),
                              // color: Color(0xffE4E4E4),
                            ),
                            InkWell(
                              onTap: () {
                                print(selectStores.toString());
                                API(context).post("stores/mass/delete", {
                                  "ids": selectStores.toString()
                                }).then((value) {
                                  if (value != null) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => ResultOverlay(
                                        "${value['message']??value['errors']??''}",
                                      ),
                                    );
                                    setState(() {
                                      selectStores=[];
                                      isSelect=false;
                                    });
                                  }
                                  Provider.of<Provider_Data>(context,listen: false).getAllStore(context);
                                });
                              },
                              child: Row(
                                children: [
                                  Text('${getTransrlate(context, 'delete')}'),
                                  Icon(
                                    CupertinoIcons.delete,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isSelect = false;
                                });
                              },
                              icon: Icon(
                                Icons.close,
                                size: 30,
                                color: Colors.black54,
                              ),
                            )
                          ],
                        ),
                      )
                          : Container(
                        height: 50,
                        color: Colors.black12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('${Data.stores.length} ${getTransrlate(context, 'store')}'),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isSelect
                                      ? isSelect = false
                                      : isSelect = true;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_box,
                                    color: Colors.black45,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('${getTransrlate(context, 'select')}')
                                ],
                              ),
                              // color: Color(0xffE4E4E4),
                            ),
                            // InkWell (
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
                                    builder: (_) => Sortdialog())
                                    .then((val) {
                                  print(val);
                                  API(context)
                                      .get('$url?sort_type=${val??'ASC'}')
                                      .then((value) {
                                    if (value != null) {
                                      if (value['status_code'] == 200) {
                                        setState(() {
                                          Data.stores =
                                              Store_model.fromJson(value).data;
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
                      // Row(
                      //   children: <Widget>[
                      //     SizedBox(
                      //       width: 8,
                      //     ),
                      //     Expanded(
                      //       child: Container(
                      //         padding: EdgeInsets.only(bottom: 4),
                      //         height: 72,
                      //         child: searchTextField =
                      //             AutoCompleteTextField<Store>(
                      //           key: key,
                      //           clearOnSubmit: false,
                      //           suggestions: filteredStores,
                      //           style: TextStyle(
                      //               color: Colors.black, fontSize: 16.0),
                      //           decoration: InputDecoration(
                      //               border: InputBorder.none,
                      //               hintText: getTransrlate(context, 'search'),
                      //               hintStyle: TextStyle(
                      //                 fontSize: 13,
                      //                 color: Color(0xFF5D6A78),
                      //                 fontWeight: FontWeight.w400,
                      //               )),
                      //           itemFilter: (item, query) {
                      //             return item.name
                      //                 .toLowerCase()
                      //                 .startsWith(query.toLowerCase());
                      //           },
                      //           itemSorter: (a, b) {
                      //             return a.name.compareTo(b.name);
                      //           },
                      //           itemSubmitted: (item) {
                      //             setState(() {
                      //               searchTextField.textField.controller.text =
                      //                   item.name;
                      //             });
                      //             debouncer.run(() {
                      //               setState(() {
                      //                 filteredStores = stores
                      //                     .where((u) =>
                      //                         (u.name.toLowerCase().contains(
                      //                             searchTextField
                      //                                 .textField.controller.text
                      //                                 .toLowerCase())) ||
                      //                         (u.address.toLowerCase().contains(
                      //                             searchTextField
                      //                                 .textField.controller.text
                      //                                 .toLowerCase())))
                      //                     .toList();
                      //               });
                      //             });
                      //           },
                      //           textChanged: (string) {
                      //             debouncer.run(() {
                      //               setState(() {
                      //                 filteredStores = stores
                      //                     .where((u) =>
                      //                         (u.name.toLowerCase().contains(
                      //                             string.toLowerCase())) ||
                      //                         (u.address.toLowerCase().contains(
                      //                             string.toLowerCase())))
                      //                     .toList();
                      //               });
                      //             });
                      //           },
                      //           itemBuilder: (context, item) {
                      //             // ui for the autocompelete row
                      //             return row(item);
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      ListView.builder(
                        itemCount: Data.stores.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Stores_item(
                            hall_model:Data.stores[index],
                            isSelect: isSelect,
                            selectStores: selectStores,
                          );
                        },
                      ),
                      SizedBox(height: 50,)
                    ],
                  ),
                ),
    );
  }



  Widget row(Store productModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          productModel.nameStore,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          productModel.address,
        ),
      ],
    );
  }

}
