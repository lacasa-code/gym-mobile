import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/widget/no_found_item.dart';

class Notification_show extends StatefulWidget {
  const Notification_show({Key key}) : super(key: key);

  @override
  _Notification_showState createState() => _Notification_showState();
}

class _Notification_showState extends State<Notification_show> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTransrlate(context, "Notification")),
      ),
      body: NotFoundItem(title: getTransrlate(context, 'NoNotification'),),
    );
  }
}
