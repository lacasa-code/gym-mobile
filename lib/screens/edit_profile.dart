import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';

class Edit_profile extends StatefulWidget {
  @override
  _Edit_profileState createState() => _Edit_profileState();
}

class _Edit_profileState extends State<Edit_profile> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController,
      namecontroler,
      emailController,
      rolesController,
      confirempasswordController;

  @override
  void initState() {
    passwordController = TextEditingController();
    namecontroler = TextEditingController();
    confirempasswordController = TextEditingController();
    emailController = TextEditingController();
    SharedPreferences.getInstance().then((pref) => {
   namecontroler.text=pref.getString('user_name'),
   emailController.text=pref.getString('user_email'),
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
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
                          } else if (value.length < 4) {
                            return getTransrlate(context, 'email') + ' < 4';
                          }
                          _formKey.currentState.save();

                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true)),

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
                            'Update profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            setState(() => loading = true);
                            API(context).post("edit/profile", {
                              "name": namecontroler.text,
                              "email": emailController.text,
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
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return getTransrlate(context, 'password');
                                } else if (value.length < 8) {
                                  return getTransrlate(context, 'password') +
                                      ' < 8';
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
                                  filled: true))
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
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return getTransrlate(context, 'password');
                              } else if (value != passwordController.text) {
                                return getTransrlate(context, 'Passwordmatch');
                              }
                              _formKey.currentState.save();

                              return null;
                            },
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
                                  'Change Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  setState(() => loading = true);
                                  API(context).post("change/password", {
                                    "password": passwordController.text,
                                    "password_confirmation": confirempasswordController.text,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
