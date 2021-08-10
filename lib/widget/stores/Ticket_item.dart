import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trkar_vendor/model/tickets_model.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';

class Ticket_item extends StatelessWidget {
  Ticket_item({Key key, this.hall_model}) : super(key: key);
  final Ticket hall_model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: ScreenUtil.getWidth(context) / 1.7,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            width: ScreenUtil.getWidth(context) / 2.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AutoSizeText(
                          '${getTransrlate(context, 'ticketsType')} : ',
                          minFontSize: 10,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        AutoSizeText(hall_model.priority,
                            minFontSize: 10,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                     Container(),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    AutoSizeText(
                      '${getTransrlate(context, 'message')} : ',
                      minFontSize: 10,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    Container(
                      width: ScreenUtil.getWidth(context)/1.5,
                      child: AutoSizeText(hall_model.message,
                          maxLines: 1,
                          minFontSize: 12,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AutoSizeText(
                          '${getTransrlate(context, 'OrderNO')} : ',
                          minFontSize: 10,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        AutoSizeText(hall_model.orderNumber.toString(),
                            minFontSize: 10,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        AutoSizeText(
                          '${getTransrlate(context, 'OrderDate')} : ',
                          minFontSize: 10,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        AutoSizeText(
                            DateFormat('yyyy-MM-dd').format(
                                DateTime.parse(hall_model.orderCreatedAt)),
                            minFontSize: 10,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AutoSizeText(
                          '${getTransrlate(context, "ticketsStats")} : ',
                          minFontSize: 10,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color:isPassed(hall_model.status))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: AutoSizeText(hall_model.Case,
                                minFontSize: 10,
                                style: TextStyle(
                                  color: isPassed(hall_model.Case),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AutoSizeText(
                          '${getTransrlate(context, 'OrderDate')} :',
                          minFontSize: 10,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        AutoSizeText("${DateFormat('yyyy-MM-dd').format(DateTime.parse(hall_model.createdAt))}",
                            minFontSize: 10,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 2,
                  color: Colors.black12,
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color isPassed(String value) {
    switch (value) {
      case 'pending':
        return Colors.amber;
        break;
      case 'solved':
        return Colors.lightGreen;
        break;
      case 'to admin':
        return Colors.orange;
        break;
      default:
        return Colors.blue;
    }
  }
}
