import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/utils/screen_size.dart';
import 'package:trkar_vendor/utils/service/API.dart';
import 'package:trkar_vendor/widget/ResultOverlay.dart';

class Product_item extends StatelessWidget {
  Product_item({Key key, this.hall_model}) : super(key: key);
  final Product hall_model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Image.network(
                "${hall_model.photo.isNotEmpty ? hall_model.photo[0].image : 'https://d3a1v57rabk2hm.cloudfront.net/outerbanksbox/betterman_mobile-copy-42/images/product_placeholder.jpg?ts=1608776387&host=www.outerbanksbox.com'}",
                height: ScreenUtil.getHeight(context) / 5,
                width: ScreenUtil.getWidth(context),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                width: ScreenUtil.getWidth(context) / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    hall_model.price == null
                        ? Container()
                        : AutoSizeText(
                            'price :' + hall_model.price.toString(),
                            minFontSize: 8,
                            maxFontSize: 14,
                            style: TextStyle(
                              color: Color(0xFF5D6A78),
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: 1,
                          ),
                  ],
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.all(2),
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
                    width: ScreenUtil.getWidth(context) / 6,
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
                  onTap: () {
                    API(context)
                        .Delete("products/?id=${hall_model.id}")
                        .then((value) {
                      showDialog(
                        context: context,
                        builder: (_) => ResultOverlay(
                         'تم حذف المنتج بنجاح',
                        ),
                      );
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.all(2),
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
                    width: ScreenUtil.getWidth(context) / 6,
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
      ),
    );
  }
}
