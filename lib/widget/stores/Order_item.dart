import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/orders_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';

class OrderItem extends StatelessWidget {
  final Order orders_model;

  OrderItem({Key key, this.orders_model, Provider_control themeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Container(
      margin: EdgeInsets.only(top: 8, left: 16, bottom: 8, right: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[200],
                blurRadius: 5.0,
                spreadRadius: 1,
                offset: Offset(0.0, 1)),
          ]),
      width: ScreenUtil.getWidth(context) / 1.25,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AutoSizeText(
                  getTransrlate(context, 'OrderNO') +
                      ' : ${orders_model.orderNumber}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5D6A78),
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 2,
                  minFontSize: 11,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  getTransrlate(context, 'totalOrder') +
                      ' : ' +
                      orders_model.orderTotal,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5D6A78),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        getTransrlate(context, 'OrderState') +
                            ' : ${orders_model.orderStatus}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5D6A78),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                orders_model.orderStatus == 'cancelled'
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FlatButton(
                            color: Colors.green,
                            padding: EdgeInsets.all(4),
                            onPressed: () {
                              API(context).post('vendor/approve/orders', {
                                "status": "1",
                                "order_id": orders_model.id
                              }).then((value) {
                                if (value != null) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ResultOverlay(
                                      value.containsKey('message')
                                          ? value['message']
                                          : 'Done',
                                    ),
                                  );
                                }
                              });
                            },
                            child: Text(
                              'Accept',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          FlatButton(
                            color: Colors.red,
                            padding: EdgeInsets.all(4),
                            onPressed: () {
                              API(context).post('vendor/cancel/order',
                                  {"order_id": orders_model.id}).then((value) {
                                if (value != null) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ResultOverlay(
                                      value.containsKey('message')
                                          ? value['message']
                                          : 'Done',
                                    ),
                                  );
                                }
                              });
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
            Divider(),
            Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              child: ExpandablePanel(
//                  hasIcon: true,
//                  iconColor: themeColor.getColor(),
//                  headerAlignment: ExpandablePanelHeaderAlignment.center,
//                  iconPlacement: ExpandablePanelIconPlacement.right,
                header: Text(
                  getTransrlate(context, 'OrderContent'),
                  style: TextStyle(color: Color(0xFF5D6A78), fontSize: 12),
                ),
                expanded: Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orders_model.orderDetails.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 7, left: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              orders_model.orderDetails[index].productName,
                              style: TextStyle(
                                  color: themeColor.getColor(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                              orders_model.orderDetails[index].quantity
                                      .toString() +
                                  ' × ' +
                                  orders_model.orderDetails[index].price
                                      .toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
