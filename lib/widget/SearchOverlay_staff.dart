import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/orders_model.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/model/user_model.dart';
import 'package:trkar_vendor/screens/edit_product.dart';
import 'package:trkar_vendor/screens/edit_staf.dart';
import 'package:trkar_vendor/screens/orderdetails.dart';
import 'package:trkar_vendor/screens/productPage.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/products/product_item.dart';
import 'package:trkar_vendor/widget/stores/Order_item.dart';
import 'package:trkar_vendor/widget/stores/user_item.dart';

import 'ResultOverlay.dart';

class SearchOverlay_Staff extends StatefulWidget {
  String url;

  SearchOverlay_Staff({this.url});

  @override
  State<StatefulWidget> createState() => SearchOverlay_StaffState();
}

class SearchOverlay_StaffState extends State<SearchOverlay_Staff>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  List<User> products = [];

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: themeColor.getColor(),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            //Nav.route(context, FilterPage());
                          },
                          child: Container(
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            color: Colors.orange,
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              height: 50,
                              color: Colors.white,
                              child: TextFormField(
                                onChanged: (string) {
                                  if (string.length >= 1) {
                                    API(context).post(widget.url, {
                                      "search_index": string,
                                    }).then((value) {
                                      if (value != null) {

                                          setState(() {
                                            products =
                                                User_model.fromJson(value).data;
                                          });

                                      }
                                    });
                                  } else {
                                    setState(() {
                                      products = [];
                                    });
                                  }
                                },
                              )
                              //   searchTextField =
                              //       AutoCompleteTextField<Product>(
                              //     key: key,
                              //     clearOnSubmit: false,
                              //     suggestions: products,
                              //     style: TextStyle(
                              //         color: Colors.black, fontSize: 16.0),
                              //     decoration: InputDecoration(
                              //         border: InputBorder.none,
                              //         hintText:getTransrlate(context, 'search'),
                              //         hintStyle: TextStyle(
                              //           fontSize: 13,
                              //           color: Color(0xFF5D6A78),
                              //           fontWeight: FontWeight.w400,
                              //         )),
                              //     itemFilter: (item, query) {
                              //       return item
                              //           .toString()
                              //           .toLowerCase()
                              //           .startsWith(query.toLowerCase());
                              //     },
                              //     itemSorter: (a, b) {
                              //       return a.name.compareTo(b.name);
                              //     },
                              //     itemSubmitted: (item) {
                              //       setState(() {
                              // //        searchTextField.textField.controller.text = item.toString();
                              //       });
                              //     },
                              //     textChanged: (string) {
                              //       if(string.length>=1){
                              //
                              //  API(context).post(widget.url, {
                              //           "search_index": string,
                              //         }).then((value) {
                              //           if (value != null) {
                              //             if (value['status_code'] == 200) {
                              //               setState(() {
                              //                 products = Products_model.fromJson(value).product;
                              //               });
                              //             } else {
                              //               showDialog(
                              //                   context: context,
                              //                   builder: (_) => ResultOverlay(
                              //                       value['message']));
                              //             }
                              //           }
                              //         });
                              //       }else{
                              //         setState(() {
                              //           products=[];
                              //         });
                              //       }
                              //     },
                              //     itemBuilder: (context, item) {
                              //       print(item);
                              //       // ui for the autocompelete row
                              //       return row(item);
                              //     },
                              //   ),
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                    itemCount: products == null && products.isEmpty
                        ? 0
                        : products.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: [
                          User_item(
                            isSelect: products[index].isSelect,
                            hall_model: products[index],
                          ),
                          Positioned(
                              left: 40,
                              top: 20,
                              child: PopupMenuButton<int>(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: InkWell(
                                      onTap: () {
                                        _navigate_edit_hell(
                                            context, products[index]);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text("تعديل"),
                                          Icon(
                                            Icons.edit_outlined,
                                            color: Colors.black54,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: InkWell(
                                      onTap: () {
                                        API(context)
                                            .Delete("users/${products[index].id}")
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
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text("حذف"),
                                          Icon(
                                            CupertinoIcons.delete,
                                            color: Colors.black54,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              // DropdownButton<String>(
                              //   //  value: dropdownValue,
                              //   icon: Container(
                              //     child: Icon(Icons.more_vert),
                              //   ),
                              //   iconSize: 24,
                              //   elevation: 16,
                              //   style: const TextStyle(
                              //       color: Colors.deepPurple),
                              //   underline: Container(
                              //     color: Colors.deepPurpleAccent,
                              //   ),
                              //   onChanged: (String newValue) {
                              //     if (newValue == "Edit") {
                              //       _navigate_edit_hell(
                              //           context, filteredStores[index]);
                              //     } else {
                              //       API(context)
                              //           .Delete("users/${stores[index].id}")
                              //           .then((value) {
                              //         if (value != null) {
                              //           showDialog(
                              //             context: context,
                              //             builder: (_) => ResultOverlay(
                              //               value.containsKey('errors')
                              //                   ? "${value['errors']}"
                              //                   : 'تم حذف العامل بنجاح',
                              //             ),
                              //           );
                              //         }
                              //         getAllStore();
                              //       });
                              //     }
                              //   },
                              //   items: <String>[
                              //     'Edit',
                              //     'Delete',
                              //   ].map<DropdownMenuItem<String>>(
                              //       (String value) {
                              //     return DropdownMenuItem<String>(
                              //       value: value,
                              //       child: Text(value),
                              //     );
                              //   }).toList(),
                              // ),
                              ),
                        ],
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }


  _navigate_edit_hell(BuildContext context, User hall) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditStaff(hall)));
    Navigator.pop(context);
  }
}
