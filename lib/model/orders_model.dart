import 'package:trkar_vendor/model/tickets_model.dart';

class Orders_model {
  int statusCode;
  String message;
  List<Order> data;
  int total;

  Orders_model({this.statusCode, this.message, this.data, this.total});

  Orders_model.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Order>();
      json['data'].forEach((v) {
        data.add(new Order.fromJson(v));
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

class Order {
  int id;
  int userId;
  int orderNumber;
  String orderTotal;
  int expired;
  int approved;
  Shipping shipping;
  Payment payment;
  String paid;
  int status;
  String createdAt;
  String orderStatus;
  List<OrderDetails> orderDetails;

  Order(
      {this.id,
        this.userId,
        this.orderNumber,
        this.orderTotal,
        this.expired,
        this.approved,
        this.paid,
        this.status,this.payment,this.shipping,
        this.createdAt,
        this.orderStatus,
        this.orderDetails});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderNumber = json['order_number'];
    orderTotal = (json['order_total'].round()).toString();
    expired = json['expired'];
    approved = json['approved'];
    paid = json['paid'].toString();
    if(json['shipping']!=null) {
      shipping =Shipping.fromJson(json['shipping']) ;
    }
    if(json['payment']!=null) {
      payment =Payment.fromJson(json['payment']) ;
    }
    createdAt = json['created_at'];
    orderStatus = json['orderStatus'];
    if (json['orderDetails'] != null) {
      orderDetails = new List<OrderDetails>();
      json['orderDetails'].forEach((v) {
        orderDetails.add(new OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_number'] = this.orderNumber;
    data['order_total'] = this.orderTotal;
    data['expired'] = this.expired;
    data['approved'] = this.approved;
    data['paid'] = this.paid;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['orderStatus'] = this.orderStatus;
    if (this.orderDetails != null) {
      data['orderDetails'] = this.orderDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetails {
  int id;
  int orderId;
  int productId;
  int storeId;
  int vendorId;
  String productName;
  List<Photo> photo;
  String productSerial;
  String storeName;
  String vendorName;
  int quantity;
  String price;
  int discount;
  String total;
  int approved;
  String createdAt;

  OrderDetails(
      {this.id,
        this.orderId,
        this.productId,
        this.storeId,
        this.vendorId,
        this.productName,
        this.photo,
        this.productSerial,
        this.storeName,
        this.vendorName,
        this.quantity,
        this.price,
        this.discount,
        this.total,
        this.approved,
        this.createdAt});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    storeId = json['store_id'];
    vendorId = json['vendor_id'];
    productName = json['product_name'];
    if (json['photo'] != null) {
      photo = new List<Photo>();
      json['photo'].forEach((v) {
        photo.add(new Photo.fromJson(v));
      });
    }
    productSerial = json['product_serial'];
    storeName = json['store_name'];
    vendorName = json['vendor_name'];
    quantity = json['quantity'];
    price = json['price'].toString();
    discount = json['discount'];

    total = json['total'].toString();
    approved = json['approved'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['store_id'] = this.storeId;
    data['vendor_id'] = this.vendorId;
    data['product_name'] = this.productName;
    if (this.photo != null) {
      data['photo'] = this.photo.map((v) => v.toJson()).toList();
    }
    data['product_serial'] = this.productSerial;
    data['store_name'] = this.storeName;
    data['vendor_name'] = this.vendorName;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['total'] = this.total;
    data['approved'] = this.approved;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Photo {
  int id;
  int orderColumn;
  String createdAt;
  String updatedAt;
  String image;
  String url;
  String fullurl;
  String thumbnail;
  String preview;

  Photo(
      {this.id,
        this.orderColumn,
        this.createdAt,
        this.updatedAt,
        this.image,
        this.url,
        this.fullurl,
        this.thumbnail,
        this.preview});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderColumn = json['order_column'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    url = json['url'];
    fullurl = json['fullurl'];
    thumbnail = json['thumbnail'];
    preview = json['preview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_column'] = this.orderColumn;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    data['url'] = this.url;
    data['fullurl'] = this.fullurl;
    data['thumbnail'] = this.thumbnail;
    data['preview'] = this.preview;
    return data;
  }
}
