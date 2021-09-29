import 'package:trkar_vendor/model/category.dart';

class Category_model {
  int statusCode;
  String message;
  List<Category_list> data;
  int total;

  Category_model({this.statusCode, this.message, this.data, this.total});

  Category_model.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Category_list>();
      json['data'].forEach((v) {
        data.add(new Category_list.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Category_list {
  int id;
  String name;
  String nameEn;
  int allcategoryId;
  int level;
  String catName;
  List<Category_list> categories;
  Photo photo;
  String createdAt;

  Category_list(
      {this.id,
        this.name,
        this.nameEn,
        this.allcategoryId,
        this.level,
        this.catName,
        this.categories,
        this.photo,
        this.createdAt});

  Category_list.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
    allcategoryId = json['allcategory_id'];
    level = json['level'];
    catName = json['catName'];
    if (json['categories'] != null) {
      categories = new List<Category_list>();
      json['categories'].forEach((v) {
        categories.add(new Category_list.fromJson(v));
      });
    }
    if (json['photo'] != null) {
      photo=Photo.fromJson(json['photo']);

    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['allcategory_id'] = this.allcategoryId;
    data['level'] = this.level;
    data['catName'] = this.catName;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }

    data['photo'] = this.photo;
    data['created_at'] = this.createdAt;
    return data;
  }
}





