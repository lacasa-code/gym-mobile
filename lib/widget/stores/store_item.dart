import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/utils/screen_size.dart';

class Stores_item extends StatelessWidget {
  Stores_item({Key key, this.hall_model}) : super(key: key);
  final Store hall_model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: ScreenUtil.getWidth(context) - 20,
        decoration: BoxDecoration(
          color: Color(0xffeeeeee),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(0, 0),
                blurRadius: 3)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Image.network(
                "https://media4.s-nbcnews.com/i/newscms/2017_26/2053956/170627-better-grocery-store-main-se-539p_80a9ba9c8d466788799ca27568ee0d43.jpg",
                height: ScreenUtil.getHeight(context) / 4,
                width: ScreenUtil.getWidth(context),
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    width: ScreenUtil.getWidth(context) / 2.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        AutoSizeText(
                          hall_model.name,
                          minFontSize: 10,
                          style: TextStyle(
                            color: Color(0xFF5D6A78),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        AutoSizeText(
                          'Moderator Name : ${hall_model.moderatorName}',
                          minFontSize: 10,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF5D6A78),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        hall_model.address == null
                            ? Container()
                            : AutoSizeText(
                                'address :' + hall_model.address.toString(),
                                minFontSize: 8,
                                maxFontSize: 14,
                                style: TextStyle(
                                  color: Color(0xFF5D6A78),
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 1,
                              ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.2),
                                blurRadius: 6.0, // soften the shadow
                                spreadRadius: 0.0, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  1.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]),
                        width: ScreenUtil.getWidth(context) / 4,
                        child: Center(
                          child: AutoSizeText(
                            'Edit',
                            minFontSize: 10,
                            maxFontSize: 20,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.2),
                                blurRadius: 6.0, // soften the shadow
                                spreadRadius: 0.0, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  1.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ]),
                        width: ScreenUtil.getWidth(context) / 4,
                        child: Center(
                          child: AutoSizeText(
                            'Delete',
                            minFontSize: 10,
                            maxFontSize: 20,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
