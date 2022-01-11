import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/invoices.dart';
import 'package:trkar_vendor/model/packages_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';

class Invoices_information extends StatefulWidget {
  Invoices_information({Key key, this.orders_model, this.orders})
      : super(key: key);

  final Package orders_model;
   List<Package> orders;

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
            Text(getTransrlate(context, 'packages')),
          ],
        ),
        backgroundColor: themeColor.getColor(),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 8, left: 24, bottom: 8, right: 24),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                ' ${widget.orders_model.title} ',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                ' ${widget.orders_model.shortDescription} ',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),       Text(
                ' ${widget.orders_model.status} ',
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
                  itemCount: widget.orders_model.packageItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: ScreenUtil.getWidth(context) / 2,
                          child: Text(
                            widget.orders_model.packageItems[index].item.title,
                            style: TextStyle(
                                color: themeColor.getColor(),
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        AutoSizeText(
                          "${widget.orders_model.packageItems[index].status}",
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
                  itemCount: widget.orders_model.packagePrices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: ScreenUtil.getWidth(context) / 2,
                              child: AutoSizeText(
                                "${widget.orders_model.packagePrices[index].status}",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                                minFontSize: 11,
                              ),
                            ),
                            Text(
                              widget.orders_model.packagePrices[index].frequency,
                              style: TextStyle(
                                  color: themeColor.getColor(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                              "${widget.orders_model.packagePrices[index].price}",
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
