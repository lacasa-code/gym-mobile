import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/roles_model.dart';
import 'package:trkar_vendor/model/user_info.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/commons/custom_textfield.dart';
import 'package:trkar_vendor/widget/commons/drop_down_menu/find_dropdown.dart';

class add_Staff extends StatefulWidget {
  @override
  _add_StaffState createState() => _add_StaffState();
}

class _add_StaffState extends State<add_Staff> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  List<Role> roles;
  bool passwordVisible = false;
  User user = User();

  @override
  void initState() {
    getRoles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
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
            Container(
              decoration: BoxDecoration(
                  color: Color(0xffF6F6F6),
                  border: Border.all(color: Colors.black12, width: 1)),
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('إضافة عضو جديد')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextFormField(
                      intialLabel: user.name ?? ' ',
                      Keyboard_Type: TextInputType.emailAddress,
                      labelText: getTransrlate(context, 'name'),
                      hintText: getTransrlate(context, 'name'),
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return getTransrlate(context, 'name');
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        user.name = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: user.email ?? ' ',
                      Keyboard_Type: TextInputType.emailAddress,
                      labelText: getTransrlate(context, 'Email'),
                      hintText: getTransrlate(context, 'Email'),
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return getTransrlate(context, 'Email');
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        user.email = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Roles",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        child: FindDropdown<Role>(
                            items: roles,
                            dropdownBuilder: (context, selectedText) => Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 50,
                                  width: ScreenUtil.getWidth(context) / 1.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: themeColor.getColor(), width: 2),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      selectedText == null
                                          ? AutoSizeText(
                                              " Select Roles",
                                              minFontSize: 8,
                                              maxLines: 1,
                                              //overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18),
                                            )
                                          : AutoSizeText(
                                              "${selectedText.title}",
                                              minFontSize: 8,
                                              maxLines: 1,
                                              //overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: themeColor.getColor(),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ],
                                  ),
                                )),
                            dropdownItemBuilder: (context, item, isSelected) =>
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                        color: isSelected
                                            ? themeColor.getColor()
                                            : Color(0xFF5D6A78),
                                        fontSize: isSelected ? 20 : 17,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w600),
                                  ),
                                ),
                            onChanged: (item) {
                              user.roles[0].id = item.id;
                            },
                            validate: (role) {
                              return 'role';
                            },
                            labelStyle: TextStyle(fontSize: 20),
                            titleStyle: TextStyle(fontSize: 20),
                            label: " Roles",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MyTextFormField(
                      intialLabel: '',
                      Keyboard_Type: TextInputType.visiblePassword,
                      labelText: getTransrlate(context, 'password'),
                      hintText: getTransrlate(context, 'password'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black26,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                      isPassword: passwordVisible,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return getTransrlate(context, 'password');
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        user.password = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: '',
                      Keyboard_Type: TextInputType.emailAddress,
                      labelText: getTransrlate(context, 'ConfirmPassword'),
                      hintText: getTransrlate(context, 'ConfirmPassword'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black26,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                      isPassword: passwordVisible,
                      validator: (String value) {
                        if (value != user.password) {
                          return getTransrlate(context, 'Passwordmatch');
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        user.passwordConfirmation = value;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            minWidth: ScreenUtil.getWidth(context)/2.5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1),
                                side: BorderSide(color: Colors.orange,width: 1)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  getTransrlate(context, 'save'),
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  setState(() => loading = true);
                                  if (user.rolesid == null) {
                                    API(context).post("users", {
                                      "name": user.name,
                                      "email": user.email,
                                      "password": user.password,
                                      "roles": user.rolesid
                                    }).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          loading = false;
                                        });
                                        print(value.containsKey('errors'));
                                        if (value.containsKey('errors')) {
                                          showDialog(
                                            context: context,
                                            builder: (_) => ResultOverlay(
                                              value['errors'].toString(),
                                            ),
                                          );
                                        } else {
                                          Navigator.pop(context);

                                          showDialog(
                                            context: context,
                                            builder: (_) => ResultOverlay(
                                              'Done',
                                            ),
                                          );
                                        }
                                      }
                                    });
                                  }
                                }
                              }),
                          FlatButton(
                            minWidth: ScreenUtil.getWidth(context)/2.5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1),
                                side: BorderSide(color: Colors.grey,width: 1)
                              ),
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
