import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/item_model.dart';
import 'package:trkar_vendor/model/orders_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/commons/custom_textfield.dart';

class Order_information extends StatefulWidget {
  Order_information({Key key, this.orders_model, this.orders})
      : super(key: key);

  Item orders_model;
  List<Item> orders;

  @override
  _Order_informationState createState() => _Order_informationState();
}

class _Order_informationState extends State<Order_information> {
  Item item=Item();
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
            Text('${widget.orders_model.title}'),
          ],
        ),
        backgroundColor: themeColor.getColor(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("#id : ${widget.orders_model.id}"),
              MyTextFormField(
                labelText: getTransrlate(context, 'name'),
                intialLabel: "${widget.orders_model.title}",
                hintText: getTransrlate(context, 'name'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return getTransrlate(context, 'requiredempty');
                  }else   if (value.length<2) {
                    return "${getTransrlate(context, 'requiredlength')}";
                  }
                  return null;
                },
                onSaved: (String value) {
                  item.title = value;
                },),
              MyTextFormField(
                labelText: getTransrlate(context, 'description'),
                intialLabel: "${widget.orders_model.shortDescription}",
                hintText: getTransrlate(context, 'description'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return getTransrlate(context, 'requiredempty');
                  }else   if (value.length<2) {
                    return "${getTransrlate(context, 'requiredlength')}";
                  }
                  return null;
                },
                onSaved: (String value) {
                  item.title = value;
                },),
              Transform.scale(
                  scale: 2,
                  child: Switch(
                    onChanged: (v){
                      setState(() {
                        v? widget.orders_model.status='Active':widget.orders_model.status='Suspended';

                      });
                    },
                  value: widget.orders_model.status=='Active'),
                  ),
              Text("${widget.orders_model.status}", style: TextStyle(fontSize: 20),)
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
