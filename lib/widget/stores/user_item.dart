import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/user_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';

class User_item extends StatefulWidget {
  User_item({Key key, this.hall_model, this.isSelect,this.selectStores}) : super(key: key);
  final User hall_model;
  List<int> selectStores;
  bool isSelect = false;

  @override
  _User_itemState createState() => _User_itemState();
}

class _User_itemState extends State<User_item> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Padding(
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
                  : SvgPicture.asset(
                      "assets/icons/account.svg",
                      color: Colors.white,
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

                widget.hall_model.roles==null?Container():  Text(
                  "${widget.hall_model.roles.title}",
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                AutoSizeText(
                  'ID رقم : ${widget.hall_model.id}',
                  minFontSize: 10,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                AutoSizeText(
                  '${widget.hall_model.email}',
                  minFontSize: 10,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
