import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/login/login_form.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Provider_control themeColor;
  String Token;
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        Token=value.getString('token');
      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     themeColor = Provider.of<Provider_control>(context);

    return Scaffold(

        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),

              color: themeColor.getColor(),
            ),
            height: ScreenUtil.getHeight(context),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: ScreenUtil.getHeight(context)/10,),
                Center(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/trkar_logo_white.svg',
                      ),
                      Container(
                        width: ScreenUtil.getWidth(context) / 1.5,

                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Gym',style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
               LoginForm()
              ],
            ),
          ),
        ));
  }


}
