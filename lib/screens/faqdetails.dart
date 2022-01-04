import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/faq_model.dart';
import 'package:trkar_vendor/model/invoices.dart';
import 'package:trkar_vendor/model/orders_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/commons/custom_textfield.dart';

class faq_information extends StatefulWidget {
  faq_information({Key key, this.orders_model}) : super(key: key);

  final Faq orders_model;

  @override
  _faq_informationState createState() => _faq_informationState();
}

class _faq_informationState extends State<faq_information> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController answer=TextEditingController();
bool loading=false;

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/faq.svg',
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'FAQ')),
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
                  Text(" ${getTransrlate(context, 'QustOwner')}:${widget.orders_model.user_name ?? ''}",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                  Text(
                      " ${getTransrlate(context, 'QustDate')}:${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.orders_model.createdAt))}",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                ],
              ),
              Text(" ${getTransrlate(context, 'Qust')}:${widget.orders_model.bodyQuestion ?? ''}",
                  style: TextStyle(color: Colors.black, fontSize: 12)),
              widget.orders_model.product==null?Container():   Text(" ${getTransrlate(context, 'product')}:${themeColor.getlocal()=='ar'?widget.orders_model.product.name:widget.orders_model.product.nameEn ?? widget.orders_model.product.name}",
                  style: TextStyle(color: Colors.black, fontSize: 12)),
              widget.orders_model.answer==null?Container():  Row(
                children: [
                  Container(
                    width: ScreenUtil.getWidth(context)/1.3,
                    child: Text("${getTransrlate(context, 'answer')} :${widget.orders_model.answer ?? ''}",
                        style: TextStyle(color: Colors.black, fontSize: 12)),
                  ),
                  IconButton(onPressed: (){
                    answer.text= widget.orders_model.answer;
                  }, icon:Icon(
                      Icons.edit,color: Colors.black45,
                  ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: MyTextFormField(
                    textEditingController:answer,
                    Keyboard_Type: TextInputType.text,
                    labelText: "${getTransrlate(context, 'sendReplay')}",
                    hintText: '${getTransrlate(context, 'answer')}',
                    validator: (String value) {
                      if (value.isEmpty) {
                        return '${getTransrlate(context, 'answer')}';
                      }
                      _formKey.currentState.save();
                      return null;
                    },
                    onSaved: (String value) {
                      answer.text = value;
                    },
                  ),
                ),
              ),
              Center(
                child:loading?FlatButton(
                  minWidth: ScreenUtil.getWidth(context) / 2.5,
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:Container(
                      height: 30,
                      child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<Color>( Colors.white),
                          )),
                    ),
                  ),
                  onPressed: () async {
                  },
                ): GestureDetector(
                  child: Container(
                    width: ScreenUtil.getWidth(context) / 2.5,
                    padding: const EdgeInsets.all(10.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.blue)),
                    child: Center(
                      child: AutoSizeText(
                        "${getTransrlate(context, 'send')}",
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 14,
                        maxLines: 1,
                        minFontSize: 10,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ),
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() => loading = true);
                      API(context).post('vendor/answer/question', {
                        "question_id": widget.orders_model.id,
                        "answer": answer.text
                      }).then((value) {
                        if (value != null) {
                          setState(() => loading = false);

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
              widget.orders_model.product==null?Container():   Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: ScreenUtil.getWidth(context)/2,
                        child: Text(" ${getTransrlate(context, 'product')} :${widget.orders_model.product ==null? '':themeColor.getlocal()=='ar'?widget.orders_model.product.name:widget.orders_model.product.nameEn ?? widget.orders_model.product.name}",
                            style: TextStyle(color: Colors.black, fontSize: 12)),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(border: Border.all(color: Colors.black12,width: 2)),
                        child: CachedNetworkImage(
                          imageUrl:
                          "${widget.orders_model.product==null?'':widget.orders_model.product.photo[0].image}",
                          height: ScreenUtil.getHeight(context) / 8,
                          width: ScreenUtil.getWidth(context)/5,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  widget.orders_model.product.category==null?Container():   Text(" ${getTransrlate(context, 'mainCategory')} :${widget.orders_model.product==null?"": widget.orders_model.product.category==null?"":widget.orders_model.product.category.mainCategoryName ?? ''}",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                  widget.orders_model.product.description==null?Container():  Text(" ${getTransrlate(context, 'description')} :${themeColor.getlocal()=='ar'?widget.orders_model.product.description:widget.orders_model.product.descriptionEn ?? widget.orders_model.product.description}",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                  widget.orders_model.product.originCountry==null?Container():  Text(" ${getTransrlate(context, 'prodcountry')} :${widget.orders_model.product.originCountry==null?"":
                  widget.orders_model.product.originCountry.countryName?? ''}",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                  widget.orders_model.product.actualPrice==null?Container():  Text(" ${getTransrlate(context, 'price')} :${widget.orders_model.product.actualPrice ?? ''}",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                  widget.orders_model.product.carMade==null?Container(): Text(" ${getTransrlate(context, 'car')} :${widget.orders_model.product.carMade==null?"":widget.orders_model.product.carMade.carMade ?? ''}",
                      style: TextStyle(color: Colors.black, fontSize: 12)),

                ],
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
