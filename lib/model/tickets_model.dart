import 'package:trkar_vendor/model/area_model.dart';
import 'package:trkar_vendor/model/city_model.dart';
import 'package:trkar_vendor/model/orders_model.dart';

class Tickets_model {
  int statusCode;
  String message;
  List<Ticket> data;
  int total;

  Tickets_model({this.statusCode, this.message, this.data, this.total});

  Tickets_model.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Ticket>();
      json['data'].forEach((v) { data.add(new Ticket.fromJson(v)); });
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

class Ticket {
  int id;
  String ticketNo;
  String title;
  int ticketpriorityId;
  String priority;
  String message;
  String status;
  int categoryId;
  String categoryName;
  int userId;
  String userName;
  String userEmail;
  String userPhone;
  int vendorId;
  String vendorName;
  int orderId;
  Attachment attachment;
  String answer;
  List<Comments> comments;
  String Case;
  String reply;
  List<OrderDetails> orderDetails;
  int orderNumber;
  String orderCreatedAt;
  String vendorEmail;
  String createdAt;
  Shipping shipping;
  Payment payment;

  Ticket({this.id, this.ticketNo, this.title, this.ticketpriorityId, this.priority, this.message, this.status, this.categoryId, this.categoryName, this.userId, this.userName, this.userEmail, this.userPhone, this.vendorId, this.vendorName, this.orderId, this.attachment, this.answer, this.comments, this.Case, this.reply, this.orderDetails, this.orderNumber, this.orderCreatedAt, this.vendorEmail, this.createdAt, this.shipping, this.payment});

Ticket.fromJson(Map<String, dynamic> json) {
id = json['id'];
ticketNo = json['ticket_no'];
title = json['title'];
ticketpriorityId = json['ticketpriority_id'];
priority = json['priority'];
message = json['message'];
status = json['status'];
categoryId = json['category_id'];
categoryName = json['category_name'];
userId = json['user_id'];
userName = json['user_name'];
userEmail = json['user_email'];
userPhone = json['user_phone'];
vendorId = json['vendor_id'];
vendorName = json['vendor_name'];
orderId = json['order_id'];
attachment = json['attachment'] != null ? new Attachment.fromJson(json['attachment']) : null;
answer = json['answer'];
if (json['comments'] != null) {
comments = new List<Comments>();
json['comments'].forEach((v) { comments.add(new Comments.fromJson(v)); });
}
Case = json['case'];
reply = json['reply'];
if (json['orderDetails'] != null) {
orderDetails = new List<OrderDetails>();
json['orderDetails'].forEach((v) { orderDetails.add(new OrderDetails.fromJson(v)); });
}
orderNumber = json['order_number'];
orderCreatedAt = json['order_created_at'];
vendorEmail = json['vendor_email'];
createdAt = json['created_at'];
shipping = json['shipping'] != null ? new Shipping.fromJson(json['shipping']) : null;
payment = json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['ticket_no'] = this.ticketNo;
  data['title'] = this.title;
  data['ticketpriority_id'] = this.ticketpriorityId;
  data['priority'] = this.priority;
  data['message'] = this.message;
  data['status'] = this.status;
  data['category_id'] = this.categoryId;
  data['category_name'] = this.categoryName;
  data['user_id'] = this.userId;
  data['user_name'] = this.userName;
  data['user_email'] = this.userEmail;
  data['user_phone'] = this.userPhone;
  data['vendor_id'] = this.vendorId;
  data['vendor_name'] = this.vendorName;
  data['order_id'] = this.orderId;
  if (this.attachment != null) {
    data['attachment'] = this.attachment.toJson();
  }
  data['answer'] = this.answer;
  if (this.comments != null) {
    data['comments'] = this.comments.map((v) => v.toJson()).toList();
  }
  data['case'] = this.Case;
  data['reply'] = this.reply;
  if (this.orderDetails != null) {
  data['orderDetails'] = this.orderDetails.map((v) => v.toJson()).toList();
  }
  data['order_number'] = this.orderNumber;
  data['order_created_at'] = this.orderCreatedAt;
  data['vendor_email'] = this.vendorEmail;
  data['created_at'] = this.createdAt;
  if (this.shipping != null) {
  data['shipping'] = this.shipping.toJson();
  }
  if (this.payment != null) {
  data['payment'] = this.payment.toJson();
  }
  return data;
}
}

class Attachment {
  int id;
  String name;
  String image;


  Attachment({
    this.id,  this.name, this.image});

  Attachment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class Payment {
  int id;
  String paymentName;
  int status;
  String lang;

  Payment({this.id, this.paymentName, this.status, this.lang});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentName = json['payment_name'];
    status = json['status'];
    lang = json['lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['payment_name'] = this.paymentName;
    data['status'] = this.status;
    data['lang'] = this.lang;
    return data;
  }
}


class Shipping {
  int id;
  int userId;
  String userName;
  int status;
  String recipientName;
  String recipientPhone;
  String lastName;
  String street;
  String district;
  String homeNo;
  String floorNo;
  String apartmentNo;
  String telephoneNo;
  String nearestMilestone;
  String notices;
  Area area;
  City city;
  Shipping(
      {this.id,
        this.userId,
        this.userName,
        this.status,
        this.recipientName,
        this.recipientPhone,
        this.lastName,
        this.area,
        this.street,
        this.district,
        this.homeNo,
        this.floorNo,
        this.apartmentNo,
        this.telephoneNo,
        this.nearestMilestone,
        this.notices});

  Shipping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    status = json['status'];
    recipientName = json['recipient_name'];
    recipientPhone = json['recipient_phone'];
    lastName = json['last_name'];
    street = json['street'];
    district = json['district'];
    homeNo = json['home_no'];
    floorNo = json['floor_no'];
     if(json['area']!=null) {
       area = Area.fromJson(json['area']);
    };
     if(json['city']!=null) {
       city = City.fromJson(json['city']);
    };
    apartmentNo = json['apartment_no'];
    telephoneNo = json['telephone_no'];
    nearestMilestone = json['nearest_milestone'];
    notices = json['notices'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['status'] = this.status;
    data['recipient_name'] = this.recipientName;
    data['recipient_phone'] = this.recipientPhone;
    data['last_name'] = this.lastName;
    data['street'] = this.street;
    data['district'] = this.district;
    data['home_no'] = this.homeNo;
    data['floor_no'] = this.floorNo;
    data['apartment_no'] = this.apartmentNo;
    data['telephone_no'] = this.telephoneNo;
    data['nearest_milestone'] = this.nearestMilestone;
    data['notices'] = this.notices;
    return data;
  }
}

class Comments {
  int id;
  int ticketId;
  int userId;
  String userName;
  String userRole;
  String comment;
  String createdAt;

  Comments({this.id, this.ticketId, this.userId, this.userName, this.userRole, this.comment, this.createdAt});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketId = json['ticket_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userRole = json['user_role'];
    comment = json['comment'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ticket_id'] = this.ticketId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_role'] = this.userRole;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    return data;
  }
}


