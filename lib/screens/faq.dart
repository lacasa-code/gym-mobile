import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trkar_vendor/screens/faqdetails.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/Provider/provider_data.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/model/faq_model.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay.dart';
import 'package:trkar_vendor/widget/Sort.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';
import 'package:trkar_vendor/widget/no_found_item.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<Faq> faq;
  String url = "vendor/fetch/question";
  int i = 2;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        PerFaq(context);
      }
    });
    getFaq();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Scaffold(
      drawer: HiddenMenu(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/faq.svg',
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'FAQ')),
          ],
        ),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.search,
          //     color: Colors.white,
          //   ),
          //   onPressed: (){
          //     showDialog(
          //       context: context,
          //       builder: (_) => SearchOverlay(),
          //     );},
          // )
        ],
        backgroundColor: themeColor.getColor(),
      ),
      body: faq == null
          ? Center(child: CircularProgressIndicator())
          : faq.isEmpty
          ? Center(child:NotFoundItem(title:'${getTransrlate(context, 'NoFAQ')}'))
          : Container(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      color: Colors.black12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                              '${faq.length} ${getTransrlate(context, 'Qustions')}'),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => Sortdialog()).then((val) {
                                print(val);
                                url='vendor/fetch/question?sort_type=${val}';
                                getFaq();
                              });
                            },
                            child: Row(
                              children: [
                                Text('${getTransrlate(context, 'Sort')}'),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                      itemCount: faq.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            _navigate_edit_hell(context, faq[index]);
                          },
                          child: Container(
                              padding: EdgeInsets.all(16.0),
                              color: index.isEven
                                  ? Colors.white
                                  : Color(0xffF6F6F6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text(
                                      //     " ${faq[index].id ?? ''}",
                                      //     style: TextStyle(
                                      //         color: Colors.black,
                                      //         fontSize: 12)),
                                      Text(
                                          " ${getTransrlate(context, 'QustOwner')}: ${faq[index].user_name ?? ''}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                      Text(
                                          " ${getTransrlate(context, 'QustDate')}:${DateFormat('yyyy-MM-dd').format(DateTime.parse(faq[index].createdAt))}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ],
                                  ),
                                  Text(
                                      " ${getTransrlate(context, 'Qust')}:${faq[index].bodyQuestion ?? ''}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12)),
                                  faq[index].product == null
                                      ? Container()
                                      : Text(
                                          " ${getTransrlate(context, 'product')}: ${faq[index].product.name ?? ''}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                  faq[index].answer == null
                                      ? Container()
                                      : Text(
                                          " ${getTransrlate(context, 'answer')} : ${faq[index].answer ?? ''}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                ],
                              )),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void getFaq() {
     i = 2;
    SharedPreferences.getInstance().then((value) => {
          API(context).post('$url',
              {"vendor_id": value.getInt('user_id')}).then((value) {
            if (value != null) {
              setState(() {
                faq = Faq_model.fromJson(value).data;
              });
            }
          })
        });
  }
  Future<void> PerFaq(BuildContext context) async {
    SharedPreferences.getInstance().then((value) => {

    API(context).post("$url${url.contains('?')?'&':'?'}page=${i++}", {"vendor_id": value.getInt('user_id')}).then((value) {

     print(value);
     if (value != null) {
        setState(() {
          faq.addAll(Faq_model.fromJson(value).data);
        });

      }
    })});
  }
  _navigate_edit_hell(BuildContext context, Faq faq) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => faq_information(
                  orders_model: faq,
                )));
    Timer(Duration(seconds: 3), () => getFaq());
  }
}
