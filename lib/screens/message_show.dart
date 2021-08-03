import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';

class Message_show extends StatefulWidget {
  const Message_show({Key key}) : super(key: key);

  @override
  _Message_showState createState() => _Message_showState();
}

class _Message_showState extends State<Message_show> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTransrlate(context, "message")),
      ),
    );
  }
}
