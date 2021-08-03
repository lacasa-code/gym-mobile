import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/screens/StorePage.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';

class Stores_item extends StatefulWidget {
  Stores_item({Key key,this.hall_model, this.isSelect,this.selectStores}) : super(key: key);
  final Store hall_model;
  List<int> selectStores;
  bool isSelect = false;

  @override
  _Stores_itemState createState() => _Stores_itemState();
}

class _Stores_itemState extends State<Stores_item> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Nav.route(context, StorePage(store: widget.hall_model,));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
        child: Container(
          width: ScreenUtil.getWidth(context),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(0, 0),
                  blurRadius: 3)
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(8),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: widget.isSelect
                    ? Checkbox(
                    activeColor: Colors.orange,
                    value: widget.hall_model.isSelect,
                    onChanged: (bool value) {
                      setState(() {
                        widget.hall_model.isSelect = value;
                      });
                      !widget.hall_model.isSelect? widget.selectStores.remove(widget.hall_model.id) :widget.selectStores.add(widget.hall_model.id);
                    })
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                  "assets/icons/store.svg",
                  color: Colors.white,
                ),
                    ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    widget.hall_model.name,
                    minFontSize: 10,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  Row(
                    children: [
                      Text(
                        "رقم الجوال : ",
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 13),
                      ),
                      Text(
                        "${widget.hall_model.moderatorPhone}",
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      AutoSizeText(
                        'العنوان : ',
                        minFontSize: 10,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        width: ScreenUtil.getWidth(context)/2,
                        child: AutoSizeText(
                          '${widget.hall_model.address}',
                          minFontSize: 10,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
