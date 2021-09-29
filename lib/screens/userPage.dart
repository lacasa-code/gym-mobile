
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/model/user_model.dart';
import 'package:trkar_vendor/screens/edit_staf.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay_staff.dart';

class UserPage extends StatefulWidget {
  User user;

  UserPage({Key key,this.user}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

@override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    final data = Provider.of<Provider_Data>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/staff.svg',
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'staff')),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: (){
              showDialog(
                context: context,
                builder: (_) => SearchOverlay_Staff(url: 'users/search/name',),
              );},
          )
        ],
        backgroundColor: themeColor.getColor(),
      ),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(8),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(5),
              ),
              child:  Padding(
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
                  widget.user.name,
                  minFontSize: 10,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                Text(
                  "${widget.user.roles.title}",
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                AutoSizeText(
                  'ID رقم : ${widget.user.id}',
                  minFontSize: 10,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                AutoSizeText(
                  '${widget.user.email}',
                  minFontSize: 10,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                AutoSizeText(
                  '${getTransrlate(context, 'stores')}',
                  minFontSize: 10,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                widget.user.stores == null
                    ? Container()
                    : Container(
                  width: ScreenUtil.getWidth(context) / 1.5,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.user.stores.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: ScreenUtil.getWidth(context) / 2,
                            child: Text(
                              " ${widget.user.stores[index].nameStore}",
                              style: TextStyle(
                                //color: themeColor.getColor(),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
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
                      Nav.route(context, EditStaff(widget.user));
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
                      API(context)
                          .Delete("users/${widget.user.id}")
                          .then((value) {
                        if (value != null) {
                          showDialog(
                            context: context,
                            builder: (_) => ResultOverlay(
                              value.containsKey('errors')
                                  ? "${value['errors']}"
                                  : '${value['message']??value['errors'] ??'تم حذف العامل بنجاح '}'
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
