import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/roles_model.dart';
import 'package:trkar_vendor/model/user_model.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/commons/custom_textfield.dart';
import 'package:trkar_vendor/widget/commons/drop_down_menu/find_dropdown.dart';

class EditStaff extends StatefulWidget {
  EditStaff(this.user);

  User user;

  @override
  _EditStaffState createState() => _EditStaffState();
}

class _EditStaffState extends State<EditStaff> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  List<Role> roles;
  bool passwordVisible = false;

  @override
  void initState() {
    getRoles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Container(
                height: ScreenUtil.getHeight(context) / 1.5,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextFormField(
                        intialLabel: widget.user.name ?? ' ',
                        Keyboard_Type: TextInputType.name,
                           labelText: getTransrlate(context, 'name'),inputFormatters: [
                            new LengthLimitingTextInputFormatter(200),
                          ],
                        hintText: getTransrlate(context, 'name'),
                        isPhone: true,
                        enabled: true,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return getTransrlate(context, 'requiredempty');
                          } else if (value.length <= 2) {
                            return "${getTransrlate(context, 'requiredlength')}";
                          } else if (RegExp(r"^[+-]?([0-9]*[.])?[0-9]+")
                              .hasMatch(value)) {
                            return getTransrlate(context, 'invalidname');
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          widget.user.name = value;
                        },
                      ),
                      MyTextFormField(
                        intialLabel: widget.user.email ?? ' ',
                        Keyboard_Type: TextInputType.emailAddress,
                        labelText: getTransrlate(context, 'Email'),
                        hintText: getTransrlate(context, 'Email'),
                        isPhone: true,
                        enabled: false,
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
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${getTransrlate(context, 'role')}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      roles == null
                          ? Container()
                          : DropdownSearch<Role>(
                              maxHeight: ScreenUtil.getWidth(context) / 3,
                              showSearchBox: false,
                              showClearButton: false,
                              selectedItem: widget.user.roles,
                              label: "   ",
                              validator: (Role item) {
                                if (item == null) {
                                  return "Required field";
                                } else
                                  return null;
                              },
                              items: roles,
                              //  onFind: (String filter) => getData(filter),
                              itemAsString: (Role u) => u.title,
                              onChanged: (Role data) =>
                                  widget.user.rolesid = data.id.toString()),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
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
                    FlatButton(
                        minWidth: ScreenUtil.getWidth(context) / 2.5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1),
                            side: BorderSide(color: Colors.orange, width: 1)),
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
                            print("users/${widget.user.id}");
                            print({
                              "name": widget.user.name,
                              "email": widget.user.email,
                              "roles": widget.user.rolesid
                            });
                            API(context).Put("users/${widget.user.id}", {
                              "name": widget.user.name,
                              "email": widget.user.email,
                              "roles": widget.user.rolesid??widget.user.roles.id
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
                                      '${getTransrlate(context,'Done')}',
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
