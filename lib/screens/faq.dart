import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trkar_vendor/screens/faqdetails.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/model/faq_model.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay.dart';
import 'package:trkar_vendor/widget/Sort.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';

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
          : Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      color: Colors.black12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('${faq.length<=1?'${faq.length} سؤال':faq.length<=2?' سؤالين':'${faq.length} أسئلة'}'),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              // showDialog(
                              //     context: context,
                              //     builder: (_) => Filterdialog());
                            },
                            child: Row(
                              children: [
                                Text('تصفية'),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => Sortdialog())
                                  .then((val) {
                                print(val);

                              });
                            },
                            child: Row(
                              children: [
                                Text('ترتيب'),
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
                           onTap: (){
                             Nav.route(context, faq_information(orders_model: faq[index],));
                           },
                          child: Container(
                              padding: EdgeInsets.all(16.0),
                              color:index.isEven ?Colors.white:Color(0xffF6F6F6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(" ${getTransrlate(context, 'QustOwner')}: ${faq[index].user_name??''}",
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 12)),
                                      Text(" ${getTransrlate(context, 'QustDate')}:${DateFormat('yyyy-MM-dd').format(DateTime.parse(faq[index].createdAt))}",
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 12)),
                                    ],
                                  ),
                                  Text(" ${getTransrlate(context, 'Qust')}:${faq[index].bodyQuestion??''}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12)),
                                  faq[index].product==null?Container(): Text(" ${getTransrlate(context, 'product')}: ${faq[index].product.name??''}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12)),
                                  faq[index].answer==null?Container(): Text(" ${getTransrlate(context, 'answer')} : ${faq[index].answer??''}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12)),


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
    SharedPreferences.getInstance().then((value) => {
    API(context).post('vendor/fetch/question', {"vendor_id": value.getInt('user_id')}).then(
    (value) {
    if (value != null) {
    setState(() {
    faq = Faq_model.fromJson(value).data;
    });
    }
    })
    });

  }
}
