import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/screens/Edit_product.dart';
import 'package:trkar_vendor/screens/productPage.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/products/product_item.dart';

import 'ResultOverlay.dart';

class SearchOverlay extends StatefulWidget {
  String url;

  SearchOverlay({this.url});

  @override
  State<StatefulWidget> createState() => SearchOverlayState();
}

class SearchOverlayState extends State<SearchOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  List<Product> products = [];
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
                                        if (value['status_code'] == 200) {
                                          setState(() {
                                            products =
                                                Products_model.fromJson(value).product;
                                          });
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (_) => ResultOverlay(
                                                  value['message']));
                                        }
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
                      return InkWell(
                        onTap: (){
                          Nav.route(context, ProductPage(product: products[index],));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                          child: Stack(
                            children: [
                              Product_item(
                                hall_model: products[index],
                                isSelect: false,
                                //selectStores: selectProduct,
                              ),
                            products[index].approved==0?Container():   Positioned(
                                  left:themeColor.getlocal()=='ar'?20: null,
                                  right:themeColor.getlocal()=='en'?20:null,
                                  child: PopupMenuButton<int>(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        child: InkWell(
                                          onTap: (){
                                            _navigate_edit_hell(context, products[index]);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              Text("${getTransrlate(context, 'edit')}"),
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
                                        child:  InkWell(
                                          onTap: (){
                                            Delete_Products(products[index].id);
                                            products.remove(products[index]);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              Text("${getTransrlate(context, 'delete')}"),
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

                              ),

                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
  _navigate_edit_hell(BuildContext context, Product hall) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Edit_Product(hall)));
  }
  Future<void> Delete_Products(int id) async {
    API(context).Delete('products/$id').then((value) {
      if (value != null) {
        print(value.containsKey('errors'));
        Provider.of<Provider_Data>(context,listen: false).getProducts(context,"products");

        showDialog(
          context: context,
          builder: (_) => ResultOverlay(
            value.containsKey('errors') ? value['errors'] : '${getTransrlate(context,'Done')}',
          ),
        );
      }
    });
  }



}
