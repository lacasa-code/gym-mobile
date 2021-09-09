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
    products_select=[];
    products.forEach((element) {
      element.isSelect=true;
     products_select.add(element.id);
      notifyListeners();

    });
  }
  setAllStores_selectt() async {
    Stores_select=[];

    stores.forEach((element) {
      element.isSelect=true;
      Stores_select.add(element.id);
      notifyListeners();
    });
  }
  setAllStaff_selectt() async {
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

  Future<void> getAllstaff(BuildContext context) async {
    staff=null;

    API(context).get("users").then((value) {
      if (value != null) {
           staff = User_model.fromJson(value).data;
           notifyListeners();

      }
    });
  }
  Future<void> getAllStore(BuildContext context) async {
    stores=null;
    API(context).get("stores").then((value) {
      if (value != null) {
           stores = Store_model.fromJson(value).data;
           notifyListeners();

      }
    });
  }
  Future<void> PerStore(BuildContext context) async {
    API(context).get("stores?page=${Stores_page++}&ordered_by=created_at&sort_type=desc").then((value) {
      if (value != null) {
          stores.addAll(Store_model.fromJson(value).data);
          notifyListeners();

      }
    });
  }

  Future<void> getProducts(BuildContext context) async {
    products=null;
    API(context).get("products").then((value) {
      if (value != null) {
          products = Products_model.fromJson(value).product;
          notifyListeners();
      }
    });
  }
  Future<void> PerProducts(BuildContext context) async {
    API(context).get("products?page=${products_page++}&ordered_by=created_at&sort_type=desc").then((value) {
      if (value != null) {
          products.addAll(Products_model.fromJson(value).product);
          notifyListeners();

      }
    });
  }
}
