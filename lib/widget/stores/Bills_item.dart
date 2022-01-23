import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/bill_model.dart';
import 'package:trkar_vendor/model/invoices.dart';
import 'package:trkar_vendor/model/orders_model.dart';
import 'package:trkar_vendor/model/packages_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';

class BillsItem extends StatelessWidget {
  final Bill orders_model;

  BillsItem({Key key, this.orders_model, Provider_control themeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Container(
      margin: EdgeInsets.only(top: 8, left: 16, bottom: 8, right: 16),
      width: ScreenUtil.getWidth(context) / 1.25,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'billNo: ${orders_model.billNo??''} ',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),       Text(
                'Amount: ${orders_model.amount} ',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'dueDate: ${orders_model.dueDate} ',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'ShortDescription: ${orders_model.shortDescription} ',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),       Text(
                'Status: ${orders_model.status} ',
                style: TextStyle(
                  fontSize: 13,
                  color: themeColor.getColor(),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          InkWell(onTap: (){
            API(context).post("pay/bill/${orders_model.id}", {
              "short_description":"${orders_model.shortDescription}",
              "amount":"${orders_model.amount}",
              "paymentmethod_id":"1"
            }).then((value) {
              print(value);
              if (value != null) {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (_) => ResultOverlay(
                      value['message'].toString(),
                    ),
                  );
                }else{
                  showDialog(
                    context: context,
                    builder: (_) => ResultOverlay(
                      value['message']??value['errors'],
                    ),
                  );}});
          },child: Container(child: Text("Pay now")))
        ],
      ),
    );
  }
}
