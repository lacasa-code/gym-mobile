import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/faq_model.dart';
import 'package:trkar_vendor/model/invoices.dart';
import 'package:trkar_vendor/model/orders_model.dart';
import 'package:trkar_vendor/model/tickets_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/commons/custom_textfield.dart';

class tickets_information extends StatefulWidget {
  tickets_information({Key key, this.orders_model}) : super(key: key);

  final Ticket orders_model;

  @override
  _tickets_informationState createState() => _tickets_informationState();
}

class _tickets_informationState extends State<tickets_information> {
  final _formKey = GlobalKey<FormState>();
  String answer;

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/tickets.svg',
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'ticket')),
          ],
        ),
        backgroundColor: themeColor.getColor(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AutoSizeText(
                        'نوع الشكوى : ',
                        minFontSize: 10,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText(widget.orders_model.priority,
                          minFontSize: 10,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      AutoSizeText(
                        'حالة الشكوى : ',
                        minFontSize: 10,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText(widget.orders_model.status,
                          minFontSize: 10,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  AutoSizeText(
                    'الرسالة : ',
                    minFontSize: 10,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  Container(
                    width: ScreenUtil.getWidth(context)/1.5,
                    child: AutoSizeText(widget.orders_model.message,
                        minFontSize: 10,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
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
                        'رقم الطلب : ',
                        minFontSize: 10,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText(widget.orders_model.orderNumber.toString(),
                          minFontSize: 10,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      AutoSizeText(
                        'تاريخ الطلب : ',
                        minFontSize: 10,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText(
                          DateFormat('yyyy-MM-dd').format(
                              DateTime.parse(widget.orders_model.orderCreatedAt)),
                          minFontSize: 10,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
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
                        'حالة الطلب : ',
                        minFontSize: 10,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border:
                            Border.all(width: 1, color:isPassed(widget.orders_model.status))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: AutoSizeText(widget.orders_model.status,
                              minFontSize: 10,
                              style: TextStyle(
                                color: isPassed(widget.orders_model.status),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      AutoSizeText(
                        'تاريخ الاستلام : 12-3-2021',
                        minFontSize: 10,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText("",
                          minFontSize: 10,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: MyTextFormField(
                    intialLabel: '  ',
                    Keyboard_Type: TextInputType.emailAddress,
                    labelText: "إرسال رد",
                    hintText: 'الاجابة',
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'الاجابة';
                      }
                      _formKey.currentState.save();
                      return null;
                    },
                    onSaved: (String value) {
                      answer = value;
                    },
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  child: Container(
                    width: ScreenUtil.getWidth(context) / 2.5,
                    padding: const EdgeInsets.all(10.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.orange)),
                    child: Center(
                      child: AutoSizeText(
                        getTransrlate(context, 'send'),
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 14,
                        maxLines: 1,
                        minFontSize: 10,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                    ),
                  ),
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      //setState(() => _isLoading = true);
                      API(context).post('vendor/answer/question', {
                        "question_id": widget.orders_model.id,
                        "answer": answer
                      }).then((value) {
                        if (value != null) {
                          if (value['status_code'] == 200) {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    ResultOverlay(value['message']));
                          } else {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    ResultOverlay(value['message']));
                          }
                        }
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 10,),
              Text(" رقم الطلب : ${widget.orders_model.orderNumber ?? ''}",
                  style: TextStyle(color: Colors.black, fontSize: 12)),
              Text(" تاريخ الطلب : ${widget.orders_model.orderCreatedAt ?? ''}",
                  style: TextStyle(color: Colors.black, fontSize: 12)),
              Text(" طريقة الدفع :${widget.orders_model.priority ?? ''}",
                  style: TextStyle(color: Colors.black, fontSize: 12)),
              Text(" شحن بواسطة :${widget.orders_model.orderNumber ?? ''}",
                  style: TextStyle(color: Colors.black, fontSize: 12)),
              Text(" إجمالي الطلب :${widget.orders_model.orderNumber ?? ''}",
                  style: TextStyle(color: Colors.black, fontSize: 12)),

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
