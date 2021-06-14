import 'dart:async';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/user_model.dart';
import 'package:trkar_vendor/screens/add_staff.dart';
import 'package:trkar_vendor/screens/edit_staf.dart';
import 'package:trkar_vendor/screens/edit_staff.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/SerachLoading.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay.dart';
import 'package:trkar_vendor/widget/Sort.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';
import 'package:trkar_vendor/widget/stores/user_item.dart';

class Staff extends StatefulWidget {
  @override
  _StaffState createState() => _StaffState();
}

class _StaffState extends State<Staff> {
  List<User> staff;
  List<int> selectStores = [];
  List<User> filteredStores;
  final debouncer = Search(milliseconds: 1000);
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<User>> key = new GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isSelect = false;

  @override
  void initState() {
    getAllStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

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
              builder: (_) => SearchOverlay(),
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
                _navigate_add_hell(context);
              },
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
              )),
        ),
      ),
      body: staff == null
          ? Container(
              height: ScreenUtil.getHeight(context) / 3,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(themeColor.getColor()),
              )))
          : staff.isEmpty
              ? Center(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Icon(Icons.check_box_outline_blank_sharp),
                        SizedBox(height: 20),
                        Text(
                          'no users found ',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
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
                                      Text('تم اختيار '),
                                      Text('( ${selectStores.length} )'),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isSelect = true;
                                      });
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
                                        Text('اختر الكل')
                                      ],
                                    ),
                                    // color: Color(0xffE4E4E4),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      print(selectStores.toString());
                                      API(context).post("users/mass/delete", {
                                        "ids": selectStores.toString()
                                      }).then((value) {
                                        if (value != null) {
                                          showDialog(
                                            context: context,
                                            builder: (_) => ResultOverlay(
                                              value.containsKey('errors')
                                                  ? "${value['errors']}"
                                                  : 'تم حذف العامل بنجاح',
                                            ),
                                          );
                                        }
                                        getAllStore();
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Text('حذف'),
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
                                  Text('${staff.length} عضو'),
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
                                        Text('اختيار')
                                      ],
                                    ),
                                    // color: Color(0xffE4E4E4),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (_) => Filterdialog());
                                    },
                                    child: Row(
                                      children: [
                                        Text('تصفية'),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                              context: context,
                                              builder: (_) => Sortdialog())
                                          .then((val) {
                                        print(val);
                                        if(val!=null){
                                          API(context)
                                              .get('users?sort_type=${val}')
                                              .then((value) {
                                            if (value != null) {
                                              if (value['status_code'] == 200) {
                                                setState(() {
                                                  filteredStores = staff =
                                                      User_model.fromJson(value)
                                                          .data;
                                                });
                                              } else {
                                              }
                                            }
                                          });
                                        }
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Text('ترتيب'),
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
                                // Expanded(
                                //   child: Container(
                                //     padding: EdgeInsets.only(bottom: 4),
                                //     height: 72,
                                //     child: searchTextField =
                                //         AutoCompleteTextField<User>(
                                //       key: key,
                                //       clearOnSubmit: false,
                                //       suggestions: filteredStores,
                                //       style: TextStyle(
                                //           color: Colors.black, fontSize: 16.0),
                                //       decoration: InputDecoration(
                                //           border: InputBorder.none,
                                //           hintText: getTransrlate(context, 'search'),
                                //           hintStyle: TextStyle(
                                //             fontSize: 13,
                                //             color: Color(0xFF5D6A78),
                                //             fontWeight: FontWeight.w400,
                                //           )),
                                //       itemFilter: (item, query) {
                                //         return item.name
                                //             .toLowerCase()
                                //             .startsWith(query.toLowerCase());
                                //       },
                                //       itemSorter: (a, b) {
                                //         return a.name.compareTo(b.name);
                                //       },
                                //       itemSubmitted: (item) {
                                //         setState(() {
                                //           searchTextField.textField.controller.text =
                                //               item.name;
                                //         });
                                //         debouncer.run(() {
                                //           setState(() {
                                //             filteredStores = stores
                                //                 .where((u) =>
                                //                     (u.name.toLowerCase().contains(
                                //                         searchTextField
                                //                             .textField.controller.text
                                //                             .toLowerCase())) ||
                                //                     (u.email.toLowerCase().contains(
                                //                         searchTextField
                                //                             .textField.controller.text
                                //                             .toLowerCase())))
                                //                 .toList();
                                //           });
                                //         });
                                //       },
                                //       textChanged: (string) {
                                //         debouncer.run(() {
                                //           setState(() {
                                //             filteredStores = stores
                                //                 .where((u) =>
                                //                     (u.name.toLowerCase().contains(
                                //                         string.toLowerCase())) ||
                                //                     (u.email.toLowerCase().contains(
                                //                         string.toLowerCase())))
                                //                 .toList();
                                //           });
                                //         });
                                //       },
                                //       itemBuilder: (context, item) {
                                //         // ui for the autocompelete row
                                //         return row(item);
                                //       },
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            ListView.builder(
                              itemCount: filteredStores == null && staff.isEmpty
                                  ? 0
                                  : filteredStores.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: [
                                    User_item(
                                      isSelect: isSelect,
                                      hall_model: filteredStores[index],
                                      selectStores: selectStores,
                                    ),
                                    Positioned(
                                        left: 40,
                                        top: 20,
                                        child: PopupMenuButton<int>(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: InkWell(
                                                onTap: (){
                                                        _navigate_edit_hell(
                                                            context, filteredStores[index]);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text("تعديل"),
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
                                                      .Delete("users/${staff[index].id}")
                                                      .then((value) {
                                                    if (value != null) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) => ResultOverlay(
                                                          value.containsKey('errors')
                                                              ? "${value['errors']}"
                                                              : 'تم حذف العامل بنجاح',
                                                        ),
                                                      );
                                                    }
                                                    getAllStore();
                                                  });
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text("حذف"),
                                                    Icon(
                                                      CupertinoIcons.delete,
                                                      color: Colors.black54,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                        // DropdownButton<String>(
                                        //   //  value: dropdownValue,
                                        //   icon: Container(
                                        //     child: Icon(Icons.more_vert),
                                        //   ),
                                        //   iconSize: 24,
                                        //   elevation: 16,
                                        //   style: const TextStyle(
                                        //       color: Colors.deepPurple),
                                        //   underline: Container(
                                        //     color: Colors.deepPurpleAccent,
                                        //   ),
                                        //   onChanged: (String newValue) {
                                        //     if (newValue == "Edit") {
                                        //       _navigate_edit_hell(
                                        //           context, filteredStores[index]);
                                        //     } else {
                                        //       API(context)
                                        //           .Delete("users/${stores[index].id}")
                                        //           .then((value) {
                                        //         if (value != null) {
                                        //           showDialog(
                                        //             context: context,
                                        //             builder: (_) => ResultOverlay(
                                        //               value.containsKey('errors')
                                        //                   ? "${value['errors']}"
                                        //                   : 'تم حذف العامل بنجاح',
                                        //             ),
                                        //           );
                                        //         }
                                        //         getAllStore();
                                        //       });
                                        //     }
                                        //   },
                                        //   items: <String>[
                                        //     'Edit',
                                        //     'Delete',
                                        //   ].map<DropdownMenuItem<String>>(
                                        //       (String value) {
                                        //     return DropdownMenuItem<String>(
                                        //       value: value,
                                        //       child: Text(value),
                                        //     );
                                        //   }).toList(),
                                        // ),
                                        ),
                                  ],
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

  _navigate_add_hell(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => add_Staff()));
    Timer(Duration(seconds: 3), () => getAllStore());
  }

  _navigate_edit_hell(BuildContext context, User hall) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditStaff(hall)));
    Timer(Duration(seconds: 3), () => getAllStore());
  }

  Future<void> getAllStore() async {
    API(context).get('users').then((value) {
      if (value != null) {
        setState(() {
          filteredStores = staff = User_model.fromJson(value).data;
        });
      }
    });
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
