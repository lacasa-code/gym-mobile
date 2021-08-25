import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/invoices.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';

class Invoices_information extends StatefulWidget {
  Invoices_information({Key key, this.orders_model, this.orders})
      : super(key: key);

  final Invoice orders_model;
   List<Invoice> orders;

  @override
  _Invoices_informationState createState() => _Invoices_informationState();
}

class _Invoices_informationState extends State<Invoices_information> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/orders.svg',
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'invoices')),
          ],
        ),
        backgroundColor: themeColor.getColor(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 8, left: 8, bottom: 8, right: 8),
              width: ScreenUtil.getWidth(context) / 1.25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AutoSizeText(
                    getTransrlate(context, 'OrderNO') +
                        ' : ${widget.orders_model.orderNumber}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    minFontSize: 11,
                  ),
                  AutoSizeText(
                    getTransrlate(context, 'OrderDate') +
                        ' :' +
                        DateFormat('yyyy-MM-dd').format(
                            DateTime.parse(widget.orders_model.createdAt)),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    minFontSize: 11,
                  ),
                  AutoSizeText(
                    getTransrlate(context, 'paymentMethod') +
                            ' :' +
                            "${widget.orders_model.payment.paymentName}" ??
                        ' ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    minFontSize: 11,
                  ),
                  AutoSizeText(
                    getTransrlate(context, 'addressShipping') + " : ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 5,
                    minFontSize: 11,
                  ),
                  AutoSizeText(
                    widget.orders_model.userAddress == null
                        ? ''
                        : "${widget.orders_model.userAddress.area==null?'':widget.orders_model.userAddress.area.areaName} , "
                        "${widget.orders_model.userAddress.city==null?'':widget.orders_model.userAddress.city.cityName} , "
                        "${widget.orders_model.userAddress.street??''} , "
                        "${widget.orders_model.userAddress.district??''} , "
                        "${widget.orders_model.userAddress.floorNo??''} , "
                        "${widget.orders_model.userAddress.apartmentNo??''}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 5,
                    minFontSize: 11,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 1,
                    color: Colors.black12,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  AutoSizeText(
                    "${getTransrlate(context, 'shipping')}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 5,
                    minFontSize: 11,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.orders_model.order.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: 7,
                          left: 10,
                          top: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.orders_model
                                            .order[index].photo.isEmpty
                                        ? ""
                                        : widget.orders_model
                                            .order[index].photo[0].image,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                Container(
                                  width: ScreenUtil.getWidth(context) / 2,
                                  child: Text(
                                    themeColor.getlocal()=='ar'? widget.orders_model.order[index].productName:widget.orders_model.order[index].name_en??widget.orders_model.order[index].productName,
                                    style: TextStyle(
                                        color: themeColor.getColor(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AutoSizeText(
                                  " كمية : ${widget.orders_model.order[index].quantity}",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                  minFontSize: 11,
                                ),
                                AutoSizeText(
                                  "${widget.orders_model.order[index].total} ${getTransrlate(context, 'Currency')}",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                  minFontSize: 11,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      ' ${getTransrlate(context, 'totalOrder')} : ${widget.orders_model.invoiceTotal} ${getTransrlate(context, 'Currency')} ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }

  Color isPassed(String value) {
    switch (value) {
      case 'inprogress':
        return Colors.amber;
        break;
      case 'pending':
        return Colors.green;
        break;
      case 'cancelled due to expiration':
        return Colors.deepPurpleAccent;
        break;
      case '5':
        return Colors.greenAccent;
      case 'cancelled':
        return Colors.red;
        break;
      default:
        return Colors.blue;
    }
  }

}
