import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/screens/add_product.dart';
import 'package:trkar_vendor/screens/edit_product.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/products/product_item.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Product> products;

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(getTransrlate(context, 'product')),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
            child: InkWell(
                onTap: () {
                  _navigate_add_hell(context);
                },
                child: Text(getTransrlate(context, 'addProduct'))),
          )
        ],
        backgroundColor: themeColor.getColor(),
      ),
      body: products == null
          ? Container(
              height: ScreenUtil.getHeight(context) / 3,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(themeColor.getColor()),
              )))
          : products.isEmpty
              ? Center(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Icon(Icons.check_box_outline_blank_sharp),
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
                  child: Container(
                    height: ScreenUtil.getHeight(context)-80 ,
                    width: ScreenUtil.getWidth(context) ,
                    child: ResponsiveGridList(
                      desiredItemWidth: ScreenUtil.getWidth(context)/2.2,
                      minSpacing: 10,
                      children: products.map((product) =>  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffeeeeee),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: Offset(0, 0),
                                  blurRadius: 3)
                            ],
                          ),
                          child: Column(
                            children: [
                              Product_item(
                                hall_model: product,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _navigate_edit_hell(
                                          context, product);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      margin: EdgeInsets.all(2),
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
                                      width: ScreenUtil.getWidth(context) / 6,
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
                                      Delete_Products(product.id);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      margin: EdgeInsets.all(2),
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
                                      width: ScreenUtil.getWidth(context) / 6,
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
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                ),
    );
  }

  _navigate_add_hell(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Add_Product()));
    Timer(Duration(seconds: 3), () => getProducts());
  }

  _navigate_edit_hell(BuildContext context, Product hall) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Edit_Product(hall)));
    Timer(Duration(seconds: 3), () => getProducts());
  }

  Future<void> getProducts() async {
    API(context).get('products').then((value) {
      if (value != null) {
        setState(() {
          products = Products_model.fromJson(value).product;
        });
        print(products.toString());
      }
    });
  }

  Future<void> Delete_Products(int id) async {
    API(context).Delete('products/$id').then((value) {
      if (value != null) {
        print(value.containsKey('errors'));
        showDialog(
          context: context,
          builder: (_) => ResultOverlay(
            value.containsKey('errors') ? value['errors'] : 'Done',
          ),
        );
      }
      getProducts();
    });
  }
}
