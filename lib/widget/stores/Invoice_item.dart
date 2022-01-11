import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/invoices.dart';
import 'package:trkar_vendor/model/orders_model.dart';
import 'package:trkar_vendor/model/packages_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';

class InvoiceItem extends StatelessWidget {
  final Package orders_model;

  InvoiceItem({Key key, this.orders_model, Provider_control themeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Container(
      margin: EdgeInsets.only(top: 8, left: 16, bottom: 8, right: 16),
      width: ScreenUtil.getWidth(context) / 1.25,
      child:  Column(
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
          Text(getTransrlate(context, 'Myorders')),

          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orders_model.packageItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: ScreenUtil.getWidth(context) / 2,
                      child: Text(
                        orders_model.packageItems[index].item.title,
                        style: TextStyle(
                            color: themeColor.getColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                    AutoSizeText(
                      "${orders_model.packageItems[index].status}",
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      minFontSize: 11,
                    ),
                  ],
                );
              },
            ),
          ),
          Text(getTransrlate(context, 'packages')),

          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orders_model.packagePrices.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: ScreenUtil.getWidth(context) / 2,
                          child: AutoSizeText(
                            "${orders_model.packagePrices[index].status}",
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                            minFontSize: 11,
                          ),
                        ),
                        Text(
                          orders_model.packagePrices[index].frequency,
                          style: TextStyle(
                              color: themeColor.getColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Text(
                          "${orders_model.packagePrices[index].price}",
                          style: TextStyle(
                              color: themeColor.getColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),

                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
