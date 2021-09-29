import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/user_model.dart';
import 'package:trkar_vendor/screens/add_staff.dart';
import 'package:trkar_vendor/screens/edit_staf.dart';
import 'package:trkar_vendor/screens/userPage.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/SerachLoading.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay_staff.dart';
import 'package:trkar_vendor/widget/Sort.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';
import 'package:trkar_vendor/widget/no_found_item.dart';
import 'package:trkar_vendor/widget/stores/user_item.dart';

class Staff extends StatefulWidget {
  @override
  _StaffState createState() => _StaffState();
}

class _StaffState extends State<Staff> {
  final debouncer = Search(milliseconds: 1000);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isSelect = false;
  String url="users";
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    Provider.of<Provider_Data>(context,listen: false).getAllstaff(context,url);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<Provider_Data>(context,listen: false).PerStaff(context,url);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    final data = Provider.of<Provider_Data>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: HiddenMenu(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FlatButton(
              color: Colors.orange,
              onPressed: () {
                Nav.route(context, add_Staff());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    Text(
                      getTransrlate(context, 'addstaff'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )),
        ),
      ),
      body: data.staff == null
          ? Container(
              height: ScreenUtil.getHeight(context) / 3,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(themeColor.getColor()),
              )))
          : data.staff.isEmpty
              ? Center(
                  child: NotFoundItem(title: '${getTransrlate(context, 'NoUsersFound')}' ,),
                )
              : SingleChildScrollView(
        controller: _scrollController,
                child: Column(
                    children: [
                      isSelect
                          ? Container(
                              height: 50,
                              color: Colors.black12,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Text('${getTransrlate(context, 'select')}'),
                                      Text('( ${data.staff_select.length} )'),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      data.setAllStaff_selectt();

                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Colors.black45,
                                          size: 25,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('${getTransrlate(context, 'SelectAll')}')
                                      ],
                                    ),
                                    // color: Color(0xffE4E4E4),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      API(context).post("users/mass/delete", {
                                        "ids": data.staff_select.toString()
                                      }).then((value) {
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
                                        data.getAllstaff(context,url);
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Text('${getTransrlate(context, 'delete')}'),
                                        Icon(
                                          CupertinoIcons.delete,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isSelect = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      size: 30,
                                      color: Colors.black54,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              height: 50,
                              color: Colors.black12,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('${data.staff.length} ${getTransrlate(context, 'staf')}'),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isSelect
                                            ? isSelect = false
                                            : isSelect = true;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_box,
                                          color: Colors.black45,
                                          size: 25,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('${getTransrlate(context, 'select')}')
                                      ],
                                    ),
                                    // color: Color(0xffE4E4E4),
                                  ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     // showDialog(
                                  //     //     context: context,
                                  //     //     builder: (_) => Filterdialog());
                                  //   },
                                  //   child: Row(
                                  //     children: [
                                  //       Text('تصفية'),
                                  //       Icon(
                                  //         Icons.keyboard_arrow_down,
                                  //         size: 20,
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                              context: context,
                                              builder: (_) => Sortdialog())
                                          .then((val) {
                                            print(val);
                                        if(val!=null){
                                          data.setstaff(null);
                                          url = 'users?sort_type=${val ?? 'ASC'}';
                                          data.getAllstaff(context,url);
                                        }
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Text('${getTransrlate(context, 'Sort')}'),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                              ],
                            ),
                            ListView.builder(
                              itemCount:data.staff.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: (){
                                    Nav.route(context, UserPage(user: data.staff[index],));
                                  },
                                  child: User_item(
                                    isSelect: isSelect,
                                    hall_model: data.staff[index],
                                    selectStores: data.staff_select,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ),
    );
  }


 

  Widget row(User productModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          productModel.name,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          productModel.email,
        ),
      ],
    );
  }
}
