import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/model/faq_model.dart';
import 'package:trkar_vendor/utils/service/API.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<Faq> faq;
  @override
  void initState() {
getFaq();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(getTransrlate(context, 'FAQ')),),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              getTransrlate(context, 'FAQ'),
              style: TextStyle(
                  fontSize: 18, color: Color(0xFF5D6A78)),
            ),
            Container(
                width: 28,
                child: Divider(
                  color: themeColor.getColor(),
                  height: 3,
                  thickness: 2,
                )),
            SizedBox(
              height: 16,
            ),
            faq==null?Center(child: CircularProgressIndicator()):Container(
              height: ScreenUtil.getHeight(context) - 200,
              child: ListView.builder(
                itemCount: faq.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionTile(
                     title: Text(
                       faq[index].question,
                       style: TextStyle(
                           fontSize: 14,
                           fontWeight: FontWeight.bold,
                           color: Colors.grey[600]),
                     ),

                     children: [Container(
                         padding: EdgeInsets.all(16.0),
                         color: Color(0xffFAF1E2),
                         child: Text(
                             faq[index].answer,
                             style:
                             TextStyle(color: Colors.grey, fontSize: 12)))]);
                },
              ),
            ),

//            Container(
//              height: ScreenUtil.getHeight(context)-200,
//              child: ListView(
//                children: <Widget>[
//
//                  ... panels.map((panel)=>ExpansionTile(
//                      title: Text(
//                        panel.title,
//                        style: TextStyle(
//                            fontSize: 14,
//                            fontWeight: FontWeight.bold,
//                            color: Colors.grey[600]),
//                      ),
//
//                      children: [Container(
//                          padding: EdgeInsets.all(16.0),
//                          color: Color(0xffFAF1E2),
//                          child: Text(
//                              panel.content,
//                              style:
//                              TextStyle(color: Colors.grey, fontSize: 12)))])).toList(),
//
//                ],
//              ),
//            ),
          ],
        ),
      ),
    );
  }

  void getFaq() {
    API(context).get('FAQs').then((value) {
      if (value != null) {
        setState(() {
          faq = Faq_model.fromJson(value).data;
        });
      }
    });
  }


}

