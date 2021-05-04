import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trkar_vendor/model/invoices.dart';
import 'package:trkar_vendor/utils/screen_size.dart';

class Invoice_item extends StatelessWidget {
  Invoice_item({Key key, this.hall_model}) : super(key: key);
  final Invoice hall_model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: ScreenUtil.getWidth(context) / 1.7,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                width: ScreenUtil.getWidth(context) / 2.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      hall_model.invoiceNumber.toString(),
                      minFontSize: 10,
                      style: TextStyle(
                        color: Color(0xFF5D6A78),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AutoSizeText(
                      'Invoice Total : ${hall_model.invoiceTotal}',
                      minFontSize: 10,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5D6A78),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AutoSizeText(
                      'Status : ${hall_model.status}',
                      minFontSize: 10,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5D6A78),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    hall_model.vendorName == null
                        ? Container()
                        : AutoSizeText(
                            'Vendor Name :' + hall_model.vendorName.toString(),
                            minFontSize: 8,
                            maxFontSize: 14,
                            style: TextStyle(
                              color: Color(0xFF5D6A78),
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: 1,
                          ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
