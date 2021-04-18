import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/utils/screen_size.dart';

class Product_item extends StatelessWidget {
  Product_item({Key key, this.hall_model}) : super(key: key);
  final Product hall_model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.getWidth(context) - 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Image.network(
              "${hall_model.photo.isNotEmpty ? hall_model.photo[0].image : 'https://d3a1v57rabk2hm.cloudfront.net/outerbanksbox/betterman_mobile-copy-42/images/product_placeholder.jpg?ts=1608776387&host=www.outerbanksbox.com'}",
              height: ScreenUtil.getHeight(context) / 6,
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
        ],
      ),
    );
  }
}
