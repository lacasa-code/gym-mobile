import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
class Custom_Loading extends StatelessWidget {
  const Custom_Loading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: ScreenUtil.getHeight(context) / 4,
        width: ScreenUtil.getWidth(context) / 1.5,
        child: Image.asset(
          'assets/images/splashscreen-trkar-logo.gif',
        ),
      ),
    );
  }
}
