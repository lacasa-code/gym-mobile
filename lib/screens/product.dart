import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/screens/add_product.dart';
import 'package:trkar_vendor/screens/Edit_product.dart';
import 'package:trkar_vendor/screens/productPage.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay.dart';
import 'package:trkar_vendor/widget/Sort.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';
import 'package:trkar_vendor/widget/products/product_item.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  String url="products";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isSelect = false;
  List<int> selectProduct = [];
  ScrollController _scrollController = new ScrollController();
  String  characters= "ASC";
  Provider_Data data;
  @override
  void initState() {
    data=Provider.of<Provider_Data>(context,listen: false);
    data.getProducts(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
       data.PerProducts(context);
      }
    });
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
              'assets/icons/ic_shopping_cart_bottom.svg',
              height: 30,
              width: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'products')),
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
                builder: (_) => SearchOverlay(url: 'products/search/dynamic',),
              );
            },
          )
        ],
        backgroundColor: themeColor.getColor(),
      ),
      drawer: HiddenMenu(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FlatButton(
              color: Colors.orange,
              onPressed: () {
                _navigate_add_hell(context);
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
                      getTransrlate(context, 'addProduct'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )),
        ),
      ),
      body: data.products == null
          ? Container(
              height: ScreenUtil.getHeight(context) / 3,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(themeColor.getColor()),
              )))
          : data.products.isEmpty
              ? Center(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Icon(Icons.hourglass_empty_outlined,size: 100,color: Colors.black26,),
                        SizedBox(height: 20),
                        Text(
                          'no Products found ',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Text('تم اختيار '),
                                      Text('( ${selectProduct.length} )'),
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
                                      print(selectProduct.toString());
                                      API(context).post("products/mass/delete", {
                                        "ids": selectProduct.toString()
                                      }).then((value) {
                                        print(value.toString());

                                        if (value != null) {
                                          showDialog(
                                            context: context,
                                            builder: (_) => ResultOverlay(
                                             "${value['message']??value['errors']?? getTransrlate(context, 'doneDelete')}"
                                            ),
                                          );
                                          setState(() {
                                            selectProduct=null;
                                            isSelect=false;
                                          });
                                        }
                                        data.getProducts(context);
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text('${data.products.length} ${getTransrlate(context, 'product')} '),
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
                                  // InkWell(
                                  //   onTap: () {
                                  //     // showDialog(
                                  //     //     context: context,
                                  //     //     builder: (_) => Filterdialog());
                                  //   },
                                  //   child: Row(
                                  //     children: [
                                  //       Text('${getTransrlate(context, 'filter')}'),
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
                                              builder: (_) => Sortdialog(character:characters ,))
                                          .then((val) {
                                            characters=val??"ASC";
                                        print(val);
                                        API(context)
                                            .get('$url?sort_type=${characters}')
                                            .then((value) {
                                          if (value != null) {
                                            if (value['status_code'] == 200) {
                                              setState(() {
                                                data.products =
                                                    Products_model.fromJson(
                                                            value)
                                                        .product;
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
                      ListView.builder(
                          itemCount: data.products.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: (){
                                Nav.route(context, ProductPage(product: data.products[index],));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                                child: Stack(
                                  children: [
                                    Product_item(
                                      hall_model: data.products[index],
                                      isSelect: isSelect,selectStores: selectProduct,
                                    ),
                                    data.products[index].approved==0?Container():Positioned(
                                        left:themeColor.getlocal()=='ar'?20: null,
                                        right:themeColor.getlocal()=='en'?1:null,
                                        top: 20,
                                        child: PopupMenuButton<int>(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: InkWell(
                                                onTap: (){
                                                  _navigate_edit_hell(
                                                      context, data.products[index]);
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
                                                  Delete_Products(data.products[index].id);

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
                          }),
                    ],
                  ),
                ),
    );
  }

  _navigate_add_hell(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Add_Product()));
    Timer(Duration(seconds: 3), () => data.getProducts(context));
  }

  _navigate_edit_hell(BuildContext context, Product hall) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Edit_Product(hall)));
    Timer(Duration(seconds: 3), () => data.getProducts(context));
  }
  Future<void> Delete_Products(int id) async {
    API(context).Delete('products/$id').then((value) {
      if (value != null) {
        showDialog(
          context: context,
          builder: (_) => ResultOverlay(
              "${value['message']??value['errors']?? getTransrlate(context, 'doneDelete')}"
          ),
        );
      }
      data.getProducts(context);
    });
  }



}
