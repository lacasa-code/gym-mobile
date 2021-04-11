import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Cardnet extends StatefulWidget {
  @override
  _CardnetState createState() => _CardnetState();
}

class _CardnetState extends State<Cardnet> {
  String selectedUrl = 'https://card-net.com/';
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: selectedUrl,
      mediaPlaybackRequiresUserGesture: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('البطاقات'),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        child: const Center(
          child: Text('جارى التحميل .....'),
        ),
      ),
    );
  }
}
