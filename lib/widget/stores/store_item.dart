import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/screens/StorePage.dart';
import 'package:trkar_vendor/screens/edit_store.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';

class Stores_item extends StatefulWidget {
  Stores_item({Key key, this.hall_model, this.isSelect, this.selectStores})
      : super(key: key);
  final Store hall_model;
  List<int> selectStores;
  bool isSelect = false;

  @override
  _Stores_itemState createState() => _Stores_itemState();
}

class _Stores_itemState extends State<Stores_item> {

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    final Data = Provider.of<Provider_Data>(context);

    return InkWell(
      onTap: () {
        Nav.route(
            context,
            StorePage(
              store: widget.hall_model,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ?widget.hall_model.headCenter!=1?  Checkbox(
                        activeColor: Colors.orange,
                        value: widget.hall_model.isSelect,
                        onChanged: (bool value) {
                          setState(() {
                            widget.hall_model.isSelect = value;
                            !widget.hall_model.isSelect
                                ? widget.selectStores.remove(widget.hall_model.id)
                                : widget.selectStores.add(widget.hall_model.id);
                            Data.setStores_select(widget.selectStores);
                          });

                        })
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          "assets/icons/store.svg",
                          color: Colors.white,
                        ),
                      ): Padding(
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
                    widget.hall_model.nameStore,
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
                        " ${getTransrlate(context, 'phone')} : ",
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 13),
                      ),
                      Text(
                        "${widget.hall_model.moderatorPhone}",
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
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
                        '${getTransrlate(context, 'address')} : ',
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
                        width: ScreenUtil.getWidth(context) / 2,
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
                  widget.hall_model.headCenter==1? Container(
                    width: ScreenUtil.getWidth(context) / 2,
                    child: AutoSizeText(
                      'Billing Address',
                      minFontSize: 10,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ):Container(),
                  widget.hall_model.members == null
                      ? Container()
                      : Container(
                          width: ScreenUtil.getWidth(context) / 1.5,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.hall_model.members.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    width: ScreenUtil.getWidth(context) / 2,
                                    child: widget.hall_model.members[index]
                                                .name ==
                                            'not registered yet'
                                        ? Container()
                                        : Text(
                                            "${widget.hall_model.members[index].roleName} : ${widget.hall_model.members[index].name}",
                                            style: TextStyle(
                                                //color: themeColor.getColor(),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
              Expanded(child: Container()),
              PopupMenuButton<int>(

                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        Nav.route(context, Edit_Store(widget.hall_model));
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
                  widget.hall_model.headCenter==1?PopupMenuItem(
                    value: 2,
                  ):
                  PopupMenuItem(
                    value: 2,
                    child:  InkWell(
                      onTap: (){
                        Navigator.pop(context);

                        API(context)
                            .Delete("stores/${widget.hall_model.id}")
                            .then((value) {
                          showDialog(
                            context: context,
                            builder: (_) => ResultOverlay(
                              "${value['message']??value['errors'] ?? 'تم حذف المتجر بنجاح'}",
                            ),);
                          Provider.of<Provider_Data>(context,listen: false).getAllStore(context,'stores');
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
      ),
    );
  }
}
