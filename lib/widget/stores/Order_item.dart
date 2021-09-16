import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/orders_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';

class OrderItem extends StatelessWidget {
  final Order orders_model;

  OrderItem({Key key, this.orders_model, Provider_control themeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Container(
      margin: EdgeInsets.only(top: 8, left: 16, bottom: 8, right: 16),
      width: ScreenUtil.getWidth(context) / 1.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse(orders_model.createdAt)),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                minFontSize: 11,
              ),
              AutoSizeText(
                getTransrlate(context, 'OrderNO') +
                    ' : ${orders_model.orderNumber}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                minFontSize: 11,
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          ListView.builder(
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
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: CachedNetworkImage(
                            imageUrl:
                                orders_model.orderDetails[index].photo.isEmpty
                                    ? ""
                                    : orders_model
                                        .orderDetails[index].photo[0].image,
                            width: 25,
                            height: 25,
                          ),
                        ),
                        Container(
                          width: ScreenUtil.getWidth(context) / 2,
                          child: Text(
                          "${themeColor.getlocal()=='ar'?  orders_model.orderDetails[index].productName??orders_model.orderDetails[index].name_en: orders_model.orderDetails[index].name_en??orders_model.orderDetails[index].productName}",
                            style: TextStyle(
                                color: themeColor.getColor(),
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      orders_model.orderDetails[index].quantity.toString() +
                          ' × ',
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            height: 2,
          ),
          orders_model.shipping == null?Container():Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Icon(Icons.location_on_outlined),
              Container(
width: ScreenUtil.getWidth(context)/1.5,
                child: AutoSizeText(
                  orders_model.shipping == null
                      ? ''
                      : "${orders_model.shipping.area==null?'':themeColor.getlocal()=='ar'?orders_model.shipping.area.areaName:orders_model.shipping.area.name_en??orders_model.shipping.area.areaName} , "
                      "${orders_model.shipping.city==null?'':themeColor.getlocal()=='ar'?orders_model.shipping.city.cityName:orders_model.shipping.city.name_en??orders_model.shipping.city.cityName} , "
                      "${orders_model.shipping.street??''} , "
                      "${orders_model.shipping.district??''} , "
                      "${orders_model.shipping.floorNo??''} , "
                      "${orders_model.shipping.apartmentNo??''}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 5,
                  minFontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
