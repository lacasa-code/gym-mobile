import 'package:flutter/material.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/utils/service/API.dart';

class Provider_Data with ChangeNotifier {
  List<Product> products;
  String url="products";
  int i = 2;


  Future<void> getProducts(BuildContext context) async {
    API(context).get(url).then((value) {
      if (value != null) {
          products = Products_model.fromJson(value).product;
          notifyListeners();
      }
    });
  }
  Future<void> PerProducts(BuildContext context) async {
    API(context).get("$url?page=${i++}&ordered_by=created_at&sort_type=desc").then((value) {
      if (value != null) {
          products.addAll(Products_model.fromJson(value).product);
          notifyListeners();

      }
    });
  }
}
