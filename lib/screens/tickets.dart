import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:trkar_vendor/model/tickets_model.dart';
import 'package:trkar_vendor/screens/ticketsdetails.dart';
import 'package:trkar_vendor/utils/Provider/provider.dart';
import 'package:trkar_vendor/utils/SerachLoading.dart';
import 'package:trkar_vendor/utils/local/LanguageTranslated.dart';
import 'package:trkar_vendor/utils/navigator.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';
import 'package:trkar_vendor/widget/SearchOverlay.dart';
import 'package:trkar_vendor/widget/Sort.dart';
import 'package:trkar_vendor/widget/hidden_menu.dart';
import 'package:trkar_vendor/widget/stores/Ticket_item.dart';

class Tickets extends StatefulWidget {
  @override
  _TicketsState createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  List<Ticket> stores;
  List<Ticket> filteredStores;
  final debouncer = Search(milliseconds: 1000);
  String url="all/tickets";
  int i = 2;
  ScrollController _scrollController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        PerStore();
      }
    });
    getAllStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Scaffold(
      key: _scaffoldKey,
     drawer: HiddenMenu(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/tickets.svg',
              color: Colors.white,
              height: 25,
              width: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text(getTransrlate(context, 'ticket')),
          ],
        ),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.search,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       builder: (_) => SearchOverlay(),
          //     );
          //   },
          // )
        ],
        backgroundColor: themeColor.getColor(),
      ),
      body: stores == null
          ? Container(
              height: ScreenUtil.getHeight(context) / 3,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(themeColor.getColor()),
              )))
          : stores.isEmpty
              ? Center(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Icon(Icons.hourglass_empty_outlined,size: 100,color: Colors.black26,),
                        SizedBox(height: 20),
                        Text(
                          'no Tickets found ',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
        controller: _scrollController,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        color: Colors.black12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('${stores.length} ${getTransrlate(context,'ticket')}'),
                            SizedBox(
                              width: 5,
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     // showDialog(
                            //     //     context: context,
                            //     //     builder: (_) => Filterdialog());
                            //   },
                            //   child: Row(
                            //     children: [
                            //       Text('تصفية'),
                            //       Icon(
                            //         Icons.keyboard_arrow_down,
                            //         size: 20,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => Sortdialog())
                                    .then((val) {
                                  print('$url?sort_type=${val??'ASC'}');
                                  API(context)
                                      .get('$url?sort_type=${val??'ASC'}')
                                      .then((value) {
                                    if (value != null) {
                                      if (value['status_code'] == 200) {
                                        setState(() {
                                          filteredStores = stores = Tickets_model.fromJson(value).data;
                                        });
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (_) => ResultOverlay(
                                                value['errors']));
                                      }
                                    }
                                  });
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
                        itemCount: filteredStores == null && stores.isEmpty
                            ? 0
                            : filteredStores.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: (){
                              Nav.route(context, tickets_information(orders_model: filteredStores[index],));
                            },
                            child: Ticket_item(
                              hall_model: filteredStores[index],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  Future<void> getAllStore() async {
    API(context).get('all/tickets').then((value) {
      if (value != null) {
        setState(() {
          filteredStores = stores = Tickets_model.fromJson(value).data;
        });
      }
    });
  }
  Future<void> PerStore() async {
    API(context).get("$url?page=${i++}&ordered_by=created_at&sort_type=desc").then((value) {
      if (value != null) {
        setState(() {
          stores.addAll(Tickets_model.fromJson(value).data);
        });
      }
    });
  }
  Widget row(Ticket productModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          productModel.title.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          productModel.categoryName.toString(),
        ),
      ],
    );
  }
}
