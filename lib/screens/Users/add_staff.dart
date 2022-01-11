import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/country_model.dart';
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
import 'package:trkar_vendor/widget/custom_loading.dart';
import 'package:trkar_vendor/widget/no_found_item.dart';

class add_Staff extends StatefulWidget {
  @override
  _add_StaffState createState() => _add_StaffState();
}

class _add_StaffState extends State<add_Staff> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  List<Country> countries;
  bool passwordVisible = false;
  User user = User();

  @override
  void initState() {
    getCountries();
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
            Container(
              decoration: BoxDecoration(
                  color: Color(0xffF6F6F6),
                  border: Border.all(color: Colors.black12, width: 1)),
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('${getTransrlate(context, 'AddNewUser')}'),
                  ],
                ),
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
                      intialLabel: user.fname ?? ' ',
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
                        }else   if (value.length<2) {
                          return "${getTransrlate(context, 'requiredlength')}";
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        user.fname = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: user.lname ?? ' ',
                      Keyboard_Type: TextInputType.name,
                         labelText: getTransrlate(context, 'lname'),inputFormatters: [
                        new LengthLimitingTextInputFormatter(200),
                      ],
                      hintText: getTransrlate(context, 'lname'),
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return getTransrlate(context, 'requiredempty');
                        }else   if (value.length<2) {
                          return "${getTransrlate(context, 'requiredlength')}";
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        user.lname = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: user.username ?? ' ',
                      Keyboard_Type: TextInputType.name,
                         labelText: getTransrlate(context, 'Username'),inputFormatters: [
                        new LengthLimitingTextInputFormatter(200),
                      ],
                      hintText: getTransrlate(context, 'Username'),
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return getTransrlate(context, 'requiredempty');
                        }else   if (value.length<2) {
                          return "${getTransrlate(context, 'requiredlength')}";
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        user.username = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: user.mobile_number ?? ' ',
                      Keyboard_Type: TextInputType.name,
                         labelText: getTransrlate(context, 'phone'),
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(200),
                      ],
                      hintText: getTransrlate(context, 'phone'),
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return getTransrlate(context, 'requiredempty');
                        }else   if (value.length<2) {
                          return "${getTransrlate(context, 'requiredlength')}";
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        user.mobile_number = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: user.email ?? ' ',
                      Keyboard_Type: TextInputType.emailAddress,
                      labelText: getTransrlate(context, 'Email'),
                      hintText: getTransrlate(context, 'Email'),
                      isPhone: true,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(200),
                      ],
                      enabled: true,
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
                      onSaved: (String value) {
                        user.email = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("${getTransrlate(context, 'Countroy')}",style: TextStyle(color: Colors.black,fontSize: 16),),
                    SizedBox(
                      height: 10,
                    ),
                    countries == null
                        ? Container()
                        : DropdownSearch<Country>(
                        showSearchBox: false,
                        showClearButton: false,
                        maxHeight: ScreenUtil.getHeight(context)/3,
                        label: "   ",
                        validator: (Country item) {
                          if (item == null) {
                            return "${getTransrlate(context, 'Required')}";
                          } else
                            return null;
                        },
                        items: countries,
                        //  onFind: (String filter) => getData(filter),
                        itemAsString: (Country u) =>
                        u.name,
                        onChanged: (Country data) => user.countries__id = data.id.toString()),
                    MyTextFormField(
                      intialLabel: user.address_line_1 ?? ' ',
                      Keyboard_Type: TextInputType.name,
                      labelText: getTransrlate(context, 'Address'),inputFormatters: [
                      new LengthLimitingTextInputFormatter(200),
                    ],
                      hintText: getTransrlate(context, 'Address'),
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return getTransrlate(context, 'requiredempty');
                        }else   if (value.length<2) {
                          return "${getTransrlate(context, 'requiredlength')}";
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        user.address_line_1 = value;
                      },
                    ),
                    MyTextFormField(
                      intialLabel: user.address_line_2 ?? ' ',
                      Keyboard_Type: TextInputType.name,
                      labelText: getTransrlate(context, 'Address2'),inputFormatters: [
                      new LengthLimitingTextInputFormatter(200),
                    ],
                      hintText: getTransrlate(context, 'Address2'),
                      isPhone: true,
                      enabled: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return getTransrlate(context, 'requiredempty');
                        }else   if (value.length<2) {
                          return "${getTransrlate(context, 'requiredlength')}";
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        user.address_line_2 = value;
                      },
                    ),
                    MyTextFormField(
                      labelText: getTransrlate(context, 'password'),
                      hintText: getTransrlate(context, 'password'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          passwordVisible ? Icons.visibility : Icons.visibility_off,
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
                          return getTransrlate(context, 'requiredempty');
                        } else if (value.length < 8) {
                          return getTransrlate(context, 'PasswordShorter');
                        } else if (!value.contains(new RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))) {
                          return "${getTransrlate(context, 'invalidpass')}";
                        }
                        _formKey.currentState.save();

                        return null;
                      },
                      onSaved: (String value) {
                        user.password = value;
                      },
                    ),
                    MyTextFormField(
                      labelText: getTransrlate(context, 'ConfirmPassword'),
                      hintText: getTransrlate(context, 'ConfirmPassword'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          passwordVisible ? Icons.visibility : Icons.visibility_off,
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
                          return getTransrlate(context, 'requiredempty');
                        } else if (value != user.password) {
                          return getTransrlate(context, 'Passwordmatch');
                        }

                        _formKey.currentState.save();

                        return null;
                      },
                      onSaved: (String value) {
                        user.password_confirmation = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
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
                      ): FlatButton(
                          minWidth: ScreenUtil.getWidth(context) / 2.5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1),
                              side: BorderSide(
                                  color: Colors.blue, width: 1)),
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
                              API(context).post("add/customer", user.toJson()).then((value) {
                                print(value);
                                if (value != null) {
                                  setState(() {
                                    loading = false;
                                  });
                                  if (value['status_code']==200)  {
                                    data.getAllstaff(context,'customers');
                                    // data.getAllStore(context,'stores');
                                     Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (_) => ResultOverlay(
                                        value['message'].toString(),
                                      ),
                                    );
                                  }else{
                                    showDialog(
                                      context: context,
                                      builder: (_) => ResultOverlay(
                                       value['message']??value['errors'],
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
                              side:
                              BorderSide(color: Colors.grey, width: 1)),
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
            SizedBox(
              height: 10,
            ),

          ],
        ),
      ),
    );
  }

  Future<void> getCountries() async {
    API(context).get('countries').then((value) {
      if (value != null) {
        setState(() {
          countries = Country_model.fromJson(value).data;
        });
      }
    });
  }
}
