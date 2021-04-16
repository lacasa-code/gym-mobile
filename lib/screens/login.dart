import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/widget/login/login_form.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(getTransrlate(context, 'login')),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: ScreenUtil.getHeight(context) / 5,
                    width: ScreenUtil.getWidth(context) / 2,
                    fit: BoxFit.contain,
                    color: themeColor.getColor(),
                  ),
                ),
              ),
              LoginForm()
            ],
          ),
        ));
  }
}
