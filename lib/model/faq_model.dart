import 'package:trkar_vendor/model/products_model.dart';

class Faq_model {
  int statusCode;
  String message;
  List<Faq> data;
  int total;

  Faq_model({this.statusCode, this.message, this.data, this.total});

  Faq_model.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Faq>();
      json['data'].forEach((v) {
        data.add(new Faq.fromJson(v));
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

class Faq {
  int id;
  int userId;
  int productId;
  int vendorId;
  String bodyQuestion;
  String answer;
  String user_name;
  String lang;
  Product product;
  String createdAt;
  String updatedAt;
  String deletedAt;

  Faq(
      {this.id,
        this.userId,
        this.productId,
        this.vendorId,
        this.bodyQuestion,
        this.answer,
        this.lang,
        this.user_name,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Faq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    user_name = json['user_name'];
    productId = json['product_id'];
    vendorId = json['vendor_id'];
    bodyQuestion = json['body_question'];
    answer = json['answer'];
   if(json['product']!=null) {
      product = Product.fromJson(json['product']);
    }
    lang = json['lang'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['vendor_id'] = this.vendorId;
    data['body_question'] = this.bodyQuestion;
    data['answer'] = this.answer;
    data['lang'] = this.lang;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
