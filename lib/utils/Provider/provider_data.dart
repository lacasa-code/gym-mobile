import 'package:flutter/material.dart';
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/model/store_model.dart';
import 'package:trkar_vendor/model/user_model.dart';
import 'package:trkar_vendor/utils/service/API.dart';

class Provider_Data with ChangeNotifier {
  List<Product> products;
  List<User> staff;
  List<Store> stores;

  int products_page = 2;
  int Stores_page = 2;
  int staff_page = 2;
  List<int>  products_select = [];
  List<int>  Stores_select = [];
  List<int>  staff_select =[];


  setproducts_select(List<int> products) async {
    products_select = products;
    notifyListeners();
  }
  setAllproducts_select() async {
    products_page=2;
    products_select=[];
    products.forEach((element) {
      element.isSelect=true;
     products_select.add(element.id);
      notifyListeners();

    });
  }
  setAllStores_selectt() async {
    Stores_select=[];
    staff_page = 2;
    stores.forEach((element) {
      element.isSelect=true;
      Stores_select.add(element.id);
      notifyListeners();
    });
  }
  setAllStaff_selectt() async {
    staff_page = 2;
    staff_select=[];
    staff.forEach((element) {
      element.isSelect=true;
      staff_select.add(element.id);
      notifyListeners();
    });
  }

  setStores_select(List<int> products) async {
    Stores_select = products;
    notifyListeners();
  }
  setStaff_select(List<int> products) async {
    staff_select = products;
    notifyListeners();
  }

  setproducts(List<Product> product) async {
    products = product;
    notifyListeners();
  }
  setstaff(List<User> staf) async {
    staff = staf;
    notifyListeners();
  }
  setStore(List<Store> staf) async {
    stores = staf;
    notifyListeners();
  }

  Future<void> getAllstaff(BuildContext context,String url) async {
    staff=null;
    staff_page = 2;

    API(context).get("$url").then((value) {
      if (value != null) {
           staff = User_model.fromJson(value).data;
           notifyListeners();

      }
    });
  }
  Future<void> PerStaff(BuildContext context,String url) async {
    API(context).get("$url${url.contains('?')?'&':'?'}page=${staff_page++}").then((value) {
      if (value != null) {
        staff.addAll(User_model.fromJson(value).data);
        notifyListeners();
      }
    });
  }
  Future<void> getAllStore(BuildContext context,String url) async {
    Stores_page=2;
    stores=null;
    API(context).get("$url").then((value) {
      if (value != null) {
           stores = Store_model.fromJson(value).data;
           notifyListeners();

      }
    });
  }
  Future<void> PerStore(BuildContext context,String url) async {
    API(context).get("${url}${url.contains('?')?'&':'?'}page=${Stores_page++}").then((value) {
      if (value != null) {
          stores.addAll(Store_model.fromJson(value).data);
          notifyListeners();

      }
    });
  }

  Future<void> getProducts(BuildContext context,String url) async {
    products_page=2;
    products=null;
    API(context).get("$url").then((value) {
      if (value != null) {
          products = Products_model.fromJson(value).product;
          notifyListeners();
      }
    });
  }
  Future<void> PerProducts(BuildContext context,String url) async {
    API(context).get("${url}${url.contains('?')?'&':'?'}page=${products_page++}").then((value) {
      if (value != null) {
          products.addAll(Products_model.fromJson(value).product);
          notifyListeners();

      }
    });
  }
}
