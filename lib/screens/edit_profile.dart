import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trkar_vendor/model/user_info.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';

import 'changePasswordPAge.dart';

class Edit_profile extends StatefulWidget {
  @override
  _Edit_profileState createState() => _Edit_profileState();
}

class _Edit_profileState extends State<Edit_profile> {
  String name, email;
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  bool _isLoading = false;
  bool loading = false;
  UserInfo userModal;
  TextEditingController birthdate =TextEditingController();
  List<String> items = ["male", "female"];
  TextEditingController _tocontroller = TextEditingController();

  String password;
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController,
      namecontroler,
      emailController,
      rolesController,
      confirempasswordController;
  submitForm() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    _isLoading = true;
    try {
      setState(() => _isLoading = false);
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    passwordController = TextEditingController();
    namecontroler = TextEditingController();
    confirempasswordController = TextEditingController();
    emailController = TextEditingController();
    API(context).post('token/data',{}).then((value) {
      if (value != null) {
          setState(() {
            userModal = UserInformation.fromJson(value).data.user;
          });
          birthdate.text=userModal.birthdate??' ';

      }
    });
    SharedPreferences.getInstance().then((value) => {
      setState(() {
        name = value.getString('user_name');
        email = value.getString('user_email');
      })
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      drawer: HiddenMenu(),
        appBar: AppBar(
          title: Row(
            children: [
              SvgPicture.asset(
                "assets/icons/User Icon.svg",
                color: Colors.white,
                height: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Text('${getTransrlate(context, 'MyProfileInfo')}'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              color: Colors.black12,
              width: ScreenUtil.getWidth(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name ?? " "),
                    Text(email ?? " "),
                  ],
                ),
              ),
            ),
            _isLoading
                ? Container(
              // height: double.infinity,
              // width: double.infinity,
                color: Colors.white,
                child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            themeColor.getColor()))))
                : userModal == null
                ? Container()
                : Container(
                color: Colors.white,
                child: Container(
                  color: Colors.white,
                  child: Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Text(
                                getTransrlate(context, 'Firstname'),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: TextFormField(
                                  initialValue: userModal.name,
                                  decoration: const InputDecoration(
                                    hintText: "أدخل الاسم",
                                  ),
                                  enabled: !_status,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return getTransrlate(context, 'requiredempty');
                                    }else   if (value.length<2) {
                                      return "${getTransrlate(context, 'requiredlength')}";
                                    }else if (RegExp(
                                        r"^[+-]?([0-9]*[.])?[0-9]+").hasMatch(value)) {
                                      return getTransrlate(context, 'invalidname');
                                    }
                                    return null;
                                  },
                                  autofocus: !_status,
                                  onSaved: (String val) =>
                                  userModal.name = val,
                                  onChanged: (String val) {
                                    userModal.name = val;
                                  },
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Text(
                                getTransrlate(context, 'Lastname'),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: TextFormField(
                                  initialValue: userModal.lastName,
                                  decoration: const InputDecoration(
                                  ),
                                  enabled: !_status,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return getTransrlate(context, 'requiredempty');
                                    }else   if (value.length<2) {
                                      return "${getTransrlate(context, 'requiredlength')}";
                                    }else if (RegExp(
                                        r"^[+-]?([0-9]*[.])?[0-9]+").hasMatch(value)) {
                                      return getTransrlate(context, 'invalidname');
                                    }
                                    return null;
                                  },
                                  autofocus: !_status,
                                  onSaved: (String val) =>
                                  userModal.lastName = val,
                                  onChanged: (String val) {
                                    userModal.lastName = val;
                                  },
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Text(
                                  getTransrlate(context, 'mail'),
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: TextFormField(
                                  initialValue: userModal.email,
                                  decoration: const InputDecoration(
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return getTransrlate(
                                          context, 'mail');
                                    }
                                    _formKey.currentState.save();
                                    return null;
                                  },
                                  enabled: !_status,
                                  onSaved: (String val) =>
                                  userModal.email = val,
                                  onChanged: (String val) =>
                                  userModal.email = val,
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Text(
                                  getTransrlate(context, 'phone'),
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: TextFormField(
                                  textAlign: TextAlign.left,
                                  initialValue: userModal.phoneNo,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(12),
                                  ],
                                  decoration: InputDecoration(),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return getTransrlate(
                                          context, 'Required');
                                    }else if (value.length<12) {
                                      return getTransrlate(
                                          context, 'Requiredlength');
                                    }
                                    _formKey.currentState.save();
                                    return null;
                                  },
                                  enabled: !_status,
                                  onSaved: (String val) =>
                                  userModal.phoneNo = "+$val",
                                  onChanged: (String val) =>
                                  userModal.phoneNo =  "+$val",
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Text(
                                  '${getTransrlate(context, 'birthDate')}',
                                )),
                            InkWell(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: TextFormField(
                                    onTap: (){
                                    _status?null:
                                      _selectDateto(context);
                                    },
                                    controller:birthdate,
                                    decoration: InputDecoration(),
                                    enabled: !_status,
                                    onSaved: (String val) =>
                                    userModal.birthdate = val,
                                    onChanged: (String val) =>
                                    userModal.birthdate = val,
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Text(
                                  '${getTransrlate(context, 'gender')}')),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 10.0,
                                  bottom: 10),
                              child: DropdownSearch<String>(
                                maxHeight: 120,
                                validator: (String item) {
                                  if (item == null) {
                                    return "Required field";
                                  } else
                                    return null;
                                },
                                items: items,
                                selectedItem: userModal.gender,
                                enabled: !_status,
                                //  onFind: (String filter) => getData(filter),
                                itemAsString: (String u) => u,
                                onChanged: (String data) =>
                                userModal.gender = data,
                              ),
                            ),

                            _status
                                ? _getEditIcon()
                                : _getActionButtons(),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Text(
                                  '${getTransrlate(context, 'password')}',
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0,bottom: 10),
                                child: TextFormField(
                                  initialValue: "123456789",
                                  decoration: InputDecoration(
                                      hintText: "أدخل كلمة المرور"),
                                  enabled: !_status,
                                  obscureText: true,
                                )),
                            _getChangePassword()
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
          ]),
        ));
  }
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      //setState(() => _isLoading = true);
                      API(context).post('user/edit/profile', {
                        "name": userModal.name,
                        "email": userModal.email,
                        "last_name": userModal.lastName,
                        "phone_no": userModal.phoneNo,
                        "birthdate": userModal.birthdate,
                        "gender": userModal.gender,
                      }).then((value) {
                        if (value != null) {
                          if (value['status_code'] == 200) {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    ResultOverlay(value['message']));
                            setState(() {
                              _status = true;
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    ResultOverlay(value['message']));
                          }
                        }
                      });
                    }
                  },
                  child: Container(
                      width: ScreenUtil.getWidth(context) / 2.5,
                      padding: const EdgeInsets.all(10.0),
                      decoration:
                      BoxDecoration(border: Border.all(color: Colors.orange)),
                      child: Center(
                        child: Text(
                          "حفظ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange),
                        ),
                      )),
                ),
              ),
              flex: 2,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  },
                  child: Container(
                      width: ScreenUtil.getWidth(context) / 2.5,
                      padding: const EdgeInsets.all(10.0),
                      decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Center(
                        child: Text(
                          "إلغاء",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      )),
                ),
              ),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getEditIcon() {
    return Center(
      child: GestureDetector(
        child: Container(
          width: ScreenUtil.getWidth(context) / 2.5,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
          child: Center(
            child: AutoSizeText(
              getTransrlate(context, 'edit'),
              overflow: TextOverflow.ellipsis,
              maxFontSize: 14,
              maxLines: 1,
              minFontSize: 10,
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            _status = false;
          });
        },
      ),
    );
  }

  Widget _getChangePassword() {
    return Center(
      child: GestureDetector(
        child: Container(
          width: ScreenUtil.getWidth(context) / 2.5,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
          child: Center(
            child: AutoSizeText(
              getTransrlate(context, 'changePassword'),
              overflow: TextOverflow.ellipsis,
              maxFontSize: 14,
              maxLines: 1,
              minFontSize: 10,
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          ),
        ),
        onTap: () {
          Nav.route(context, changePassword());
        },
      ),
    );
  }

  Future<void> _selectDateto(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,initialDate: DateTime(2005),lastDate: DateTime(2005), firstDate: DateTime(1930));
    if (picked != null)
      setState(() {
        birthdate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

}
