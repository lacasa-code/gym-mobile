/// status_code : 200
/// message : "success"
/// data : [{"id":1,"ticket_no":"gggg114125","title":"first ticket","priority":"low","message":"first ticket description","status":"open","category_id":1,"category_name":"technical","user_id":3,"user_name":"firstuser","order_id":4,"order_number":20000003,"order_created_at":"2021-03-09T09:35:12.000000Z","vendor_id":2,"vendor_name":"second  vendor","vendor_email":"second@second.com","created_at":"2021-03-08 12:20:47"},{"id":2,"ticket_no":"gggg114126","title":"second title","priority":"medium","message":"second ticket description","status":"open","category_id":2,"category_name":"sales","user_id":3,"user_name":"firstuser","order_id":5,"order_number":20000004,"order_created_at":"2021-03-09T09:36:12.000000Z","vendor_id":3,"vendor_name":"third vendor","vendor_email":"thirdv@v.com","created_at":"2021-03-08 12:20:47"},{"id":3,"ticket_no":"gggg114127","title":"third","priority":"high","message":"3 ticket description","status":"open","category_id":2,"category_name":"sales","user_id":3,"user_name":"firstuser","order_id":5,"order_number":20000004,"order_created_at":"2021-03-09T09:36:12.000000Z","vendor_id":2,"vendor_name":"second  vendor","vendor_email":"second@second.com","created_at":"2021-03-08 12:20:47"},{"id":4,"ticket_no":"gggg114128","title":"fourth","priority":"low","message":"4 ticket description","status":"open","category_id":2,"category_name":"sales","user_id":3,"user_name":"firstuser","order_id":5,"order_number":20000004,"order_created_at":"2021-03-09T09:36:12.000000Z","vendor_id":2,"vendor_name":"second  vendor","vendor_email":"second@second.com","created_at":"2021-03-08 12:20:47"},{"id":5,"ticket_no":"gggg114101","title":"fifth","priority":"low","message":"5 ticket description","status":"open","category_id":3,"category_name":"shipping","user_id":3,"user_name":"firstuser","order_id":5,"order_number":20000004,"order_created_at":"2021-03-09T09:36:12.000000Z","vendor_id":3,"vendor_name":"third vendor","vendor_email":"thirdv@v.com","created_at":"2021-03-08 12:20:47"},{"id":6,"ticket_no":"gggg114102","title":"sixth","priority":"low","message":"6 ticket description","status":"open","category_id":3,"category_name":"shipping","user_id":3,"user_name":"firstuser","order_id":6,"order_number":20000005,"order_created_at":"2021-03-09T09:37:12.000000Z","vendor_id":3,"vendor_name":"third vendor","vendor_email":"thirdv@v.com","created_at":"2021-03-08 12:20:47"},{"id":7,"ticket_no":"gggg114103","title":"seventh","priority":"medium","message":"7 ticket description","status":"open","category_id":4,"category_name":"other","user_id":3,"user_name":"firstuser","order_id":6,"order_number":20000005,"order_created_at":"2021-03-09T09:37:12.000000Z","vendor_id":2,"vendor_name":"second  vendor","vendor_email":"second@second.com","created_at":"2021-03-08 12:20:47"},{"id":8,"ticket_no":"gggg114104","title":"eighth","priority":"low","message":"8 ticket description","status":"open","category_id":1,"category_name":"technical","user_id":3,"user_name":"firstuser","order_id":6,"order_number":20000005,"order_created_at":"2021-03-09T09:37:12.000000Z","vendor_id":3,"vendor_name":"third vendor","vendor_email":"thirdv@v.com","created_at":"2021-03-08 12:20:47"},{"id":9,"ticket_no":"gggg114105","title":"ninth","priority":"high","message":"9 ticket description","status":"open","category_id":1,"category_name":"technical","user_id":3,"user_name":"firstuser","order_id":6,"order_number":20000005,"order_created_at":"2021-03-09T09:37:12.000000Z","vendor_id":2,"vendor_name":"second  vendor","vendor_email":"second@second.com","created_at":"2021-03-08 12:20:47"},{"id":10,"ticket_no":"gggg114106","title":"ten","priority":"low","message":"10 ticket description","status":"open","category_id":1,"category_name":"technical","user_id":3,"user_name":"firstuser","order_id":9,"order_number":20000008,"order_created_at":"2021-03-09T09:40:12.000000Z","vendor_id":3,"vendor_name":"third vendor","vendor_email":"thirdv@v.com","created_at":"2021-03-08 12:20:47"}]
/// total : 12

class Tickets_model {
  int _statusCode;
  String _message;
  List<Ticket> _data;
  int _total;

  int get statusCode => _statusCode;
  String get message => _message;
  List<Ticket> get data => _data;
  int get total => _total;

  Tickets_model({
      int statusCode, 
      String message, 
      List<Ticket> data,
      int total}){
    _statusCode = statusCode;
    _message = message;
    _data = data;
    _total = total;
}

  Tickets_model.fromJson(dynamic json) {
    _statusCode = json["status_code"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Ticket.fromJson(v));
      });
    }
    _total = json["total"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status_code"] = _statusCode;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    map["total"] = _total;
    return map;
  }

}

/// id : 1
/// ticket_no : "gggg114125"
/// title : "first ticket"
/// priority : "low"
/// message : "first ticket description"
/// status : "open"
/// category_id : 1
/// category_name : "technical"
/// user_id : 3
/// user_name : "firstuser"
/// order_id : 4
/// order_number : 20000003
/// order_created_at : "2021-03-09T09:35:12.000000Z"
/// vendor_id : 2
/// vendor_name : "second  vendor"
/// vendor_email : "second@second.com"
/// created_at : "2021-03-08 12:20:47"

class Ticket {
  int _id;
  String _ticketNo;
  String _title;
  String _priority;
  String _message;
  String _status;
  int _categoryId;
  String _categoryName;
  int _userId;
  String _userName;
  int _orderId;
  int _orderNumber;
  String _orderCreatedAt;
  int _vendorId;
  String _vendorName;
  String _vendorEmail;
  String _createdAt;

  int get id => _id;
  String get ticketNo => _ticketNo;
  String get title => _title;
  String get priority => _priority;
  String get message => _message;
  String get status => _status;
  int get categoryId => _categoryId;
  String get categoryName => _categoryName;
  int get userId => _userId;
  String get userName => _userName;
  int get orderId => _orderId;
  int get orderNumber => _orderNumber;
  String get orderCreatedAt => _orderCreatedAt;
  int get vendorId => _vendorId;
  String get vendorName => _vendorName;
  String get vendorEmail => _vendorEmail;
  String get createdAt => _createdAt;

  Ticket({
      int id, 
      String ticketNo, 
      String title, 
      String priority, 
      String message, 
      String status, 
      int categoryId, 
      String categoryName, 
      int userId, 
      String userName, 
      int orderId, 
      int orderNumber, 
      String orderCreatedAt, 
      int vendorId, 
      String vendorName, 
      String vendorEmail, 
      String createdAt}){
    _id = id;
    _ticketNo = ticketNo;
    _title = title;
    _priority = priority;
    _message = message;
    _status = status;
    _categoryId = categoryId;
    _categoryName = categoryName;
    _userId = userId;
    _userName = userName;
    _orderId = orderId;
    _orderNumber = orderNumber;
    _orderCreatedAt = orderCreatedAt;
    _vendorId = vendorId;
    _vendorName = vendorName;
    _vendorEmail = vendorEmail;
    _createdAt = createdAt;
}

  Ticket.fromJson(dynamic json) {
    _id = json["id"];
    _ticketNo = json["ticket_no"];
    _title = json["title"];
    _priority = json["priority"];
    _message = json["message"];
    _status = json["status"];
    _categoryId = json["category_id"];
    _categoryName = json["category_name"];
    _userId = json["user_id"];
    _userName = json["user_name"];
    _orderId = json["order_id"];
    _orderNumber = json["order_number"];
    _orderCreatedAt = json["order_created_at"];
    _vendorId = json["vendor_id"];
    _vendorName = json["vendor_name"];
    _vendorEmail = json["vendor_email"];
    _createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["ticket_no"] = _ticketNo;
    map["title"] = _title;
    map["priority"] = _priority;
    map["message"] = _message;
    map["status"] = _status;
    map["category_id"] = _categoryId;
    map["category_name"] = _categoryName;
    map["user_id"] = _userId;
    map["user_name"] = _userName;
    map["order_id"] = _orderId;
    map["order_number"] = _orderNumber;
    map["order_created_at"] = _orderCreatedAt;
    map["vendor_id"] = _vendorId;
    map["vendor_name"] = _vendorName;
    map["vendor_email"] = _vendorEmail;
    map["created_at"] = _createdAt;
    return map;
  }

}