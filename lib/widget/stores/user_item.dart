import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/user_model.dart';
import 'package:trkar_vendor/screens/edit_staf.dart';
import 'package:trkar_vendor/screens/staff.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';

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
    final data = Provider.of<Provider_Data>(context);

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
                activeColor: Colors.blue,
                      value: widget.hall_model.isSelect,
                      onChanged: (bool value) {
                        setState(() {
                          widget.hall_model.isSelect = value;
                        });
                        !widget.hall_model.isSelect? widget.selectStores.remove(widget.hall_model.id) :widget.selectStores.add(widget.hall_model.id);
                        data.setStaff_select(widget.selectStores);

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
                      color: Colors.blue,
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

                widget.hall_model.approved==0?InkWell(
                  onTap: (){
                    API(context)
                        .post("vendor/approve/staff",{
                      "staff_id":"${widget.hall_model.id}"
                    })
                        .then((value) {
                      if (value != null) {
                        data.getAllstaff(context,'users');
                        showDialog(
                          context: context,
                          builder: (_) => ResultOverlay(
                            value.containsKey('errors')
                                ? "${value['errors']}"
                                : '${value['message']}',
                          ),
                        );

                      }
                     // getAllStore();
                    });
                  },
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: [
                      Text("${getTransrlate(context, 'approved')}",style: TextStyle(decoration: TextDecoration.underline),),
                      SizedBox(width: 10,),
                      Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        color: Colors.lightGreen,
                      )
                    ],
                  ),
                ):Container(),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
            Expanded(child: SizedBox(width: 1,)),
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      Nav.route(context, EditStaff(widget.hall_model));
                    },
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        Text("${getTransrlate(context, 'edit')}"),
                        Icon(
                          Icons.edit_outlined,
                          color: Colors.black54,
                        )
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child:  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      API(context)
                          .Delete("users/${widget.hall_model.id}")
                          .then((value) {
                        if (value != null) {
                          showDialog(
                            context: context,
                            builder: (_) => ResultOverlay("${value['message']??value['errors']}"
                            ),
                          );
                        }
                        data.getAllstaff(context,'users');
                      });
                    },
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        Text("${getTransrlate(context, 'delete')}"),
                        Icon(
                          CupertinoIcons.delete,
                          color: Colors.black54,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
