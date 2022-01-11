import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/roles_model.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/model/user_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/commons/custom_textfield.dart';
import 'package:trkar_vendor/widget/commons/drop_down_menu/find_dropdown.dart';

class EditCoustomer extends StatefulWidget {
  EditCoustomer(this.user);

  User user;

  @override
  _EditCoustomerState createState() => _EditCoustomerState();
}

class _EditCoustomerState extends State<EditCoustomer> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  List<Role> roles;
  bool passwordVisible = false;
  List<Store> _listStore;

  @override
  void initState() {
    // getRoles();
    // getStore();
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
        backgroundColor: themeColor.getColor(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Container(
                  height: ScreenUtil.getHeight(context) / 1.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextFormField(
                        intialLabel: widget.user.fname ?? ' ',
                        Keyboard_Type: TextInputType.name,
                           labelText: getTransrlate(context, 'fname'),inputFormatters: [
                            new LengthLimitingTextInputFormatter(200),
                          ],
                        hintText: getTransrlate(context, 'fname'),
                        isPhone: true,
                        enabled: true,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return getTransrlate(context, 'requiredempty');
                          } else if (value.length <= 2) {
                            return "${getTransrlate(context, 'requiredlength')}";
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          widget.user.lname = value;
                        },
                      ),
                      MyTextFormField(
                        intialLabel: widget.user.username ?? ' ',
                        Keyboard_Type: TextInputType.name,
                           labelText: getTransrlate(context, 'Username'),inputFormatters: [
                            new LengthLimitingTextInputFormatter(200),
                          ],
                        hintText: getTransrlate(context, 'username'),
                        isPhone: true,
                        enabled: true,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return getTransrlate(context, 'requiredempty');
                          } else if (value.length <= 2) {
                            return "${getTransrlate(context, 'requiredlength')}";
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          widget.user.username = value;
                        },
                      ),
                      MyTextFormField(
                        intialLabel: widget.user.email ?? ' ',
                        Keyboard_Type: TextInputType.emailAddress,
                        labelText: getTransrlate(context, 'Email'),
                        hintText: getTransrlate(context, 'Email'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return getTransrlate(context, 'mail');
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                              .hasMatch(value)) {
                            return getTransrlate(context, 'invalidemail');
                          }
                          _formKey.currentState.save();
                          return null;
                        },
                        // onSaved: (String value) {
                        //   widget.user.email = value;
                        // },
                      ),

                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.5),
                      offset: Offset(0, 0),
                      blurRadius: 1)
                ],
              ),
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    loading?FlatButton(
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
                    ):   FlatButton(
                        minWidth: ScreenUtil.getWidth(context) / 2.5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1),
                            side: BorderSide(color: Colors.blue, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            getTransrlate(context, 'save'),
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            setState(() => loading = true);
                            API(context).Put("edit/customer/${widget.user.id}",widget.user.toJson()).then((value) {
                              if (value != null) {
                                setState(() {
                                  loading = false;
                                });
                                print(value.containsKey('errors'));
                                if (value['status_code']!=200) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ResultOverlay(
                                      "${value['message']??value['errors']}",
                                    ),
                                  );
                                } else {
                                  data.getAllstaff(context,'users');
                                  data.getAllStore(context,'stores');
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (_) => ResultOverlay(
                                      '${value['message']??value['errors']}',
                                    ),
                                  );
                                }
                              }
                            });
                          }
                        }),
                    FlatButton(
                        minWidth: ScreenUtil.getWidth(context) / 2.5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1),
                            side: BorderSide(color: Colors.grey, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            getTransrlate(context, 'close'),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getRoles() async {
    API(context).get('roleslist').then((value) {
      if (value != null) {
        setState(() {
          roles = Roles_model.fromJson(value).data;
        });
      }
    });
  }

}
