
import 'package:trkar_vendor/model/products_model.dart';
import 'package:trkar_vendor/model/tickets_model.dart';

class Invoices_model {
  int statusCode;
  String message;
  List<Invoice> data;
  int total;

  Invoices_model({this.statusCode, this.message, this.data, this.total});

  Invoices_model.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Invoice>();
      json['data'].forEach((v) { data.add(new Invoice.fromJson(v)); });
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

class Invoice {
  int id;
  int orderId;
  int orderNumber;
  int vendorId;
  String vendorName;
  String vendorEmail;
  int invoiceNumber;
  String userName;
  Shipping userAddress;
  Payment payment;
  String invoiceTotal;
  int status;
  String createdAt;
  List<Ordersditils> order;
  String timeCreated;
  String company;
  String phone;

  Invoice({this.id, this.orderId, this.orderNumber, this.vendorId, this.vendorName, this.vendorEmail, this.invoiceNumber, this.userName, this.userAddress, this.payment, this.invoiceTotal, this.status, this.createdAt, this.order, this.timeCreated, this.company, this.phone});

  Invoice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    vendorId = json['vendor_id'];
    vendorName = json['vendor_name'];
    vendorEmail = json['vendor_email'];
    invoiceNumber = json['invoice_number'];
    userName = json['user_name'];
    userAddress = json['user_address'] != null ? new Shipping.fromJson(json['user_address']) : null;
    payment = json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    invoiceTotal = json['invoice_total'].toString();
    status = json['status'];
    createdAt = json['created_at'];
    if (json['order'] != null) {
      order = new List<Ordersditils>();
      json['order'].forEach((v) { order.add(new Ordersditils.fromJson(v)); });
    }
    timeCreated = json['time_created'];
    company = json['company'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['order_number'] = this.orderNumber;
    data['vendor_id'] = this.vendorId;
    data['vendor_name'] = this.vendorName;
    data['vendor_email'] = this.vendorEmail;
    data['invoice_number'] = this.invoiceNumber;
    data['user_name'] = this.userName;
    if (this.userAddress != null) {
      data['user_address'] = this.userAddress.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    data['invoice_total'] = this.invoiceTotal;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    if (this.order != null) {
      data['order'] = this.order.map((v) => v.toJson()).toList();
    }
    data['time_created'] = this.timeCreated;
    data['company'] = this.company;
    data['phone'] = this.phone;
    return data;
  }
}
class Ordersditils {
  int id;
  int orderId;
  int productId;
  int storeId;
  int vendorId;
  String productName;
  String name_en;
  List<PhotoProduct> photo;
  String productSerial;
  String storeName;
  String vendorName;
  int quantity;
  int price;
  String discount;
  String total;
  int approved;
  String createdAt;
  String vendorEmail;
  String company;
  String phone;

  Ordersditils({this.id, this.orderId, this.productId, this.storeId, this.vendorId, this.productName, this.photo, this.productSerial, this.storeName, this.vendorName, this.quantity, this.price, this.discount, this.total, this.approved, this.createdAt, this.vendorEmail, this.company, this.phone});

  Ordersditils.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    name_en = json['name_en'];
    storeId = json['store_id'];
    vendorId = json['vendor_id'];
    productName = json['product_name'];
    if (json['photo'] != null) {
      photo = new List<PhotoProduct>();
      json['photo'].forEach((v) { photo.add(new PhotoProduct.fromJson(v)); });
    }
    productSerial = json['product_serial'];
    storeName = json['store_name'];
    vendorName = json['vendor_name'];
    quantity = json['quantity'];
    price = json['price'];
    discount = json['discount'].toString();
    total = json['total'].toString();
    approved = json['approved'];
    createdAt = json['created_at'];
    vendorEmail = json['vendor_email'];
    company = json['company'];
    phone = json['phone'];
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
    data['vendor_email'] = this.vendorEmail;
    data['company'] = this.company;
    data['phone'] = this.phone;
    return data;
  }
}

