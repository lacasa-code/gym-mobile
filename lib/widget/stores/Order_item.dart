import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/item_model.dart';
import 'package:trkar_vendor/model/orders_model.dart';
import 'package:trkar_vendor/screens/orderdetails.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';

class Item_item extends StatelessWidget {
  final Item orders_model;

  Item_item({Key key, this.orders_model, Provider_control themeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Container(
      margin: EdgeInsets.only(top: 8, left: 16, bottom: 8, right: 16),
      width: ScreenUtil.getWidth(context) / 1.25,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                ' ${orders_model.title} ',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                ' ${orders_model.shortDescription} ',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),       Text(
                ' ${orders_model.status} ',
                style: TextStyle(
                  fontSize: 13,
                  color: themeColor.getColor(),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    Nav.route(context, Order_information(orders_model: orders_model,));
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
                    Navigator.pop(context);
                    API(context)
                        .Delete("delete/item//${orders_model.id}")
                        .then((value) {
                      if (value != null) {
                        showDialog(
                          context: context,
                          builder: (_) => ResultOverlay("${value['message']??value['errors']}"
                          ),
                        );
                      }
                    });
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
          ),

        ],
      ),
    );
  }
}
