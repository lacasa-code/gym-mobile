import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/screens/add_product.dart';
import 'package:trkar_vendor/screens/add_store.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
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
        title: Text("Products"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
            child: InkWell(
                onTap: () {
                  _navigate_add_hell(context);
                },
                child: Text("Add Product")),
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
                  child: GridView.builder(
                    primary: false,
                    padding: EdgeInsets.all(1),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio:0.75,
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount:
                        products == null && products.isEmpty ? 0 : products.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          _navigate_edit_hell(context, products[index]);
                        },
                        child: Product_item(
                          hall_model: products[index],
                        ),
                      );
                    },
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
    // await Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => Edit_hall(hall)));
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
}
