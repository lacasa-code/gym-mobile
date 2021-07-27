import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/service/API.dart';

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
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Product>> key = new GlobalKey();
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
                            child: searchTextField =
                                AutoCompleteTextField<Product>(
                              key: key,
                              clearOnSubmit: false,
                              suggestions: products,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:getTransrlate(context, 'search'),
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF5D6A78),
                                    fontWeight: FontWeight.w400,
                                  )),
                              itemFilter: (item, query) {
                                return item
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(query.toLowerCase());
                              },
                              itemSorter: (a, b) {
                                return a.name.compareTo(b.name);
                              },
                              itemSubmitted: (item) {
                                setState(() {
                                  searchTextField.textField.controller.text =
                                      item.toString();
                                });
                              },
                              textChanged: (string) {
                                if(string.length>=1){

                           API(context).post(widget.url, {
                                    "search_index": string,
                                  }).then((value) {
                                    if (value != null) {
                                      if (value['status_code'] == 200) {
                                        setState(() {
                                          products = Products_model.fromJson(value).product;
                                        });
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (_) => ResultOverlay(
                                                value['message']));
                                      }
                                    }
                                  });
                                }else{
                                  setState(() {
                                    products=[];
                                  });
                                }
                              },
                              itemBuilder: (context, item) {
                                // ui for the autocompelete row
                                return row(item);
                              },
                            ),
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

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget row(Product productModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          productModel.name.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          productModel.price.toString(),
        ),
      ],
    );
  }
}
