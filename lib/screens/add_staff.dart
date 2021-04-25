import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/roles_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
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

  TextEditingController passwordController,
      namecontroler,
      emailController,
      rolesController,
      confirempasswordController;

  @override
  void initState() {
    getRoles();
    passwordController = TextEditingController();
    namecontroler = TextEditingController();
    rolesController = TextEditingController();
    confirempasswordController = TextEditingController();
    emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add User"),
        centerTitle: true,
        backgroundColor: themeColor.getColor(),
      ),
      body: Stack(
        children: [
          Container(
            width: ScreenUtil.getWidth(context),
            height: ScreenUtil.getHeight(context),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "name",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: namecontroler,
                        keyboardType: TextInputType.text,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return getTransrlate(context, 'name');
                          } else if (value.length < 4) {
                            return getTransrlate(context, 'name') + ' < 4';
                          }
                          _formKey.currentState.save();

                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Email",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return getTransrlate(context, 'email');
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                              .hasMatch(value)) {
                            return getTransrlate(context, 'invalidemail');
                          }
                          _formKey.currentState.save();

                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),
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
                            // onFind: (f) async {
                            //   search.run(() {
                            //     setState(() {
                            //       filteredcarmodels_data = carmodels
                            //           .where((u) =>
                            //       (u.carmodel
                            //           .toLowerCase()
                            //           .contains(f
                            //           .toLowerCase())))
                            //           .toList();
                            //     });
                            //   });
                            //   return filteredcarmodels_data;
                            // } ,
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AutoSizeText(
                                        "${selectedText == null ? ' ' : selectedText.title}",
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
                              rolesController.text = item.id.toString();
                            },
                            // onFind: (text) {
                            //
                            // },
                            labelStyle: TextStyle(fontSize: 20),
                            titleStyle: TextStyle(fontSize: 20),
                            selectedItem: Role(title: 'Select  Role'),
                            label: " Roles",
                            showSearchBox: false,
                            isUnderLine: false),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Password",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: passwordController,
                              obscureText: passwordVisible,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return getTransrlate(context, 'password');
                                } else if (value.length < 8) {
                                  return getTransrlate(context, 'password') +
                                      ' < 8';
                                } else if (!value.contains(new RegExp(
                                    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$"))) {
                                  return "one Uppercase, One Lowercase, One Number and one Special Character";
                                } else if (value !=
                                    confirempasswordController.text) {
                                  return getTransrlate(
                                      context, 'Passwordmatch');
                                }
                                _formKey.currentState.save();

                                return null;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: themeColor.getColor(),
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                ),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Confirm password",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: confirempasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: passwordVisible,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: themeColor.getColor(),
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return getTransrlate(context, 'password');
                              } else if (value.length < 8) {
                                return getTransrlate(context, 'password') +
                                    ' < 8';
                              } else if (value != passwordController.text) {
                                return getTransrlate(context, 'Passwordmatch');
                              }
                              _formKey.currentState.save();

                              return null;
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: FlatButton(
                        color: themeColor.getColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            setState(() => loading = true);
                            API(context).post("users", {
                              "name": namecontroler.text,
                              "email": emailController.text,
                              "password": passwordController.text,
                              "roles": rolesController.text
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
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
