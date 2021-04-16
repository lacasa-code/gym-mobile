/// data : [{"id":1,"user_id":1,"order_number":20000000,"order_total":"1977797.00","expired":0,"approved":1,"paid":null,"status":1,"orderStatus":"pending","orderDetails":[{"id":1,"order_id":1,"product_id":1,"store_id":3,"vendor_id":1,"product_name":"first product","product_serial":"DEDXYLizcO","store_name":"thirdstore","vendor_name":"first vendor","quantity":2,"price":10,"discount":1,"total":19.8,"approved":1},{"id":2,"order_id":1,"product_id":19,"store_id":2,"vendor_id":1,"product_name":"zzzzzzzzz","product_serial":"sasasd","store_name":"updated store h","vendor_name":"first vendor","quantity":2,"price":111111,"discount":11,"total":197777.58,"approved":1}]},{"id":2,"user_id":3,"order_number":20000001,"order_total":"110.00","expired":0,"approved":1,"paid":null,"status":1,"orderStatus":"pending","orderDetails":[{"id":3,"order_id":2,"product_id":8,"store_id":3,"vendor_id":2,"product_name":"adddd","product_serial":"dsd5q5","store_name":"thirdstore","vendor_name":"second  vendor","quantity":4,"price":20,"discount":0,"total":80,"approved":1},{"id":4,"order_id":2,"product_id":19,"store_id":3,"vendor_id":2,"product_name":"zzzzzzzzz","product_serial":"sasasd","store_name":"thirdstore","vendor_name":"second  vendor","quantity":3,"price":10,"discount":0,"total":30,"approved":1}]},{"id":3,"user_id":4,"order_number":20000002,"order_total":"280.00","expired":0,"approved":1,"paid":null,"status":1,"orderStatus":"pending","orderDetails":[{"id":6,"order_id":3,"product_id":19,"store_id":3,"vendor_id":2,"product_name":"zzzzzzzzz","product_serial":"sasasd","store_name":"thirdstore","vendor_name":"second  vendor","quantity":5,"price":20,"discount":0,"total":100,"approved":1},{"id":7,"order_id":3,"product_id":8,"store_id":3,"vendor_id":2,"product_name":"adddd","product_serial":"dsd5q5","store_name":"thirdstore","vendor_name":"second  vendor","quantity":6,"price":30,"discount":0,"total":180,"approved":1}]},{"id":4,"user_id":4,"order_number":20000003,"order_total":"300.00","expired":0,"approved":1,"paid":null,"status":1,"orderStatus":"pending","orderDetails":[{"id":8,"order_id":4,"product_id":18,"store_id":3,"vendor_id":3,"product_name":"Mercedes 2010","product_serial":"MB-10","store_name":"thirdstore","vendor_name":"third vendor","quantity":1,"price":10,"discount":0,"total":10,"approved":1},{"id":10,"order_id":4,"product_id":7,"store_id":3,"vendor_id":3,"product_name":"Lancer","product_serial":"LN-SHK92","store_name":"thirdstore","vendor_name":"third vendor","quantity":3,"price":30,"discount":0,"total":90,"approved":1},{"id":11,"order_id":4,"product_id":8,"store_id":3,"vendor_id":3,"product_name":"adddd","product_serial":"dsd5q5","store_name":"thirdstore","vendor_name":"third vendor","quantity":4,"price":40,"discount":0,"total":160,"approved":1}]},{"id":5,"user_id":3,"order_number":20000004,"order_total":"50.00","expired":0,"approved":1,"paid":null,"status":1,"orderStatus":"pending","orderDetails":[{"id":12,"order_id":5,"product_id":18,"store_id":3,"vendor_id":3,"product_name":"Mercedes 2010","product_serial":"MB-10","store_name":"thirdstore","vendor_name":"third vendor","quantity":1,"price":10,"discount":0,"total":10,"approved":1},{"id":13,"order_id":5,"product_id":19,"store_id":3,"vendor_id":2,"product_name":"zzzzzzzzz","product_serial":"sasasd","store_name":"thirdstore","vendor_name":"second  vendor","quantity":2,"price":20,"discount":0,"total":40,"approved":1}]},{"id":6,"user_id":3,"order_number":20000005,"order_total":"250.00","expired":0,"approved":1,"paid":null,"status":4,"orderStatus":"cancelled","orderDetails":[{"id":14,"order_id":6,"product_id":7,"store_id":3,"vendor_id":2,"product_name":"Lancer","product_serial":"LN-SHK92","store_name":"thirdstore","vendor_name":"second  vendor","quantity":3,"price":30,"discount":0,"total":90,"approved":1},{"id":15,"order_id":6,"product_id":8,"store_id":3,"vendor_id":3,"product_name":"adddd","product_serial":"dsd5q5","store_name":"thirdstore","vendor_name":"third vendor","quantity":4,"price":40,"discount":0,"total":160,"approved":1}]},{"id":7,"user_id":3,"order_number":20000006,"order_total":"80.00","expired":0,"approved":1,"paid":null,"status":1,"orderStatus":"pending","orderDetails":[{"id":16,"order_id":7,"product_id":18,"store_id":3,"vendor_id":2,"product_name":"Mercedes 2010","product_serial":"MB-10","store_name":"thirdstore","vendor_name":"second  vendor","quantity":4,"price":20,"discount":0,"total":80,"approved":1}]},{"id":8,"user_id":3,"order_number":20000007,"order_total":"300.00","expired":0,"approved":1,"paid":null,"status":4,"orderStatus":"cancelled","orderDetails":[{"id":17,"order_id":8,"product_id":19,"store_id":3,"vendor_id":2,"product_name":"zzzzzzzzz","product_serial":"sasasd","store_name":"thirdstore","vendor_name":"second  vendor","quantity":5,"price":60,"discount":0,"total":300,"approved":1}]},{"id":9,"user_id":3,"order_number":20000008,"order_total":"8000.00","expired":0,"approved":1,"paid":null,"status":1,"orderStatus":"pending","orderDetails":[{"id":18,"order_id":9,"product_id":18,"store_id":3,"vendor_id":3,"product_name":"Mercedes 2010","product_serial":"MB-10","store_name":"thirdstore","vendor_name":"third vendor","quantity":4,"price":2000,"discount":0,"total":8000,"approved":1}]},{"id":10,"user_id":3,"order_number":20000009,"order_total":"5000.00","expired":0,"approved":1,"paid":null,"status":1,"orderStatus":"pending","orderDetails":[{"id":19,"order_id":10,"product_id":19,"store_id":3,"vendor_id":3,"product_name":"zzzzzzzzz","product_serial":"sasasd","store_name":"thirdstore","vendor_name":"third vendor","quantity":5,"price":1000,"discount":0,"total":5000,"approved":1}]}]
/// total : 12

class Orders_model {
  List<Order> _data;
  int _total;

  List<Order> get data => _data;
  int get total => _total;

  Orders_model({List<Order> data, int total}) {
    _data = data;
    _total = total;
  }

  Orders_model.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Order.fromJson(v));
      });
    }
    _total = json["total"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    map["total"] = _total;
    return map;
  }
}

/// id : 1
/// user_id : 1
/// order_number : 20000000
/// order_total : "1977797.00"
/// expired : 0
/// approved : 1
/// paid : null
/// status : 1
/// orderStatus : "pending"
/// orderDetails : [{"id":1,"order_id":1,"product_id":1,"store_id":3,"vendor_id":1,"product_name":"first product","product_serial":"DEDXYLizcO","store_name":"thirdstore","vendor_name":"first vendor","quantity":2,"price":10,"discount":1,"total":19.8,"approved":1},{"id":2,"order_id":1,"product_id":19,"store_id":2,"vendor_id":1,"product_name":"zzzzzzzzz","product_serial":"sasasd","store_name":"updated store h","vendor_name":"first vendor","quantity":2,"price":111111,"discount":11,"total":197777.58,"approved":1}]

class Order {
  int _id;
  int _userId;
  int _orderNumber;
  String _orderTotal;
  int _expired;
  int _approved;
  dynamic _paid;
  int _status;
  String _orderStatus;
  List<OrderDetails> _orderDetails;

  int get id => _id;
  int get userId => _userId;
  int get orderNumber => _orderNumber;
  String get orderTotal => _orderTotal;
  int get expired => _expired;
  int get approved => _approved;
  dynamic get paid => _paid;
  int get status => _status;
  String get orderStatus => _orderStatus;
  List<OrderDetails> get orderDetails => _orderDetails;

  Order(
      {int id,
      int userId,
      int orderNumber,
      String orderTotal,
      int expired,
      int approved,
      dynamic paid,
      int status,
      String orderStatus,
      List<OrderDetails> orderDetails}) {
    _id = id;
    _userId = userId;
    _orderNumber = orderNumber;
    _orderTotal = orderTotal;
    _expired = expired;
    _approved = approved;
    _paid = paid;
    _status = status;
    _orderStatus = orderStatus;
    _orderDetails = orderDetails;
  }

  Order.fromJson(dynamic json) {
    _id = json["id"];
    _userId = json["user_id"];
    _orderNumber = json["order_number"];
    _orderTotal = json["order_total"];
    _expired = json["expired"];
    _approved = json["approved"];
    _paid = json["paid"];
    _status = json["status"];
    _orderStatus = json["orderStatus"];
    if (json["orderDetails"] != null) {
      _orderDetails = [];
      json["orderDetails"].forEach((v) {
        _orderDetails.add(OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["user_id"] = _userId;
    map["order_number"] = _orderNumber;
    map["order_total"] = _orderTotal;
    map["expired"] = _expired;
    map["approved"] = _approved;
    map["paid"] = _paid;
    map["status"] = _status;
    map["orderStatus"] = _orderStatus;
    if (_orderDetails != null) {
      map["orderDetails"] = _orderDetails.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// order_id : 1
/// product_id : 1
/// store_id : 3
/// vendor_id : 1
/// product_name : "first product"
/// product_serial : "DEDXYLizcO"
/// store_name : "thirdstore"
/// vendor_name : "first vendor"
/// quantity : 2
/// price : 10
/// discount : 1
/// total : 19.8
/// approved : 1

class OrderDetails {
  int _id;
  int _orderId;
  int _productId;
  int _storeId;
  int _vendorId;
  String _productName;
  String _productSerial;
  String _storeName;
  String _vendorName;
  int _quantity;
  int _price;
  int _discount;
  String _total;
  int _approved;

  int get id => _id;
  int get orderId => _orderId;
  int get productId => _productId;
  int get storeId => _storeId;
  int get vendorId => _vendorId;
  String get productName => _productName;
  String get productSerial => _productSerial;
  String get storeName => _storeName;
  String get vendorName => _vendorName;
  int get quantity => _quantity;
  int get price => _price;
  int get discount => _discount;
  String get total => _total;
  int get approved => _approved;

  OrderDetails(
      {int id,
      int orderId,
      int productId,
      int storeId,
      int vendorId,
      String productName,
      String productSerial,
      String storeName,
      String vendorName,
      int quantity,
      int price,
      int discount,
      String total,
      int approved}) {
    _id = id;
    _orderId = orderId;
    _productId = productId;
    _storeId = storeId;
    _vendorId = vendorId;
    _productName = productName;
    _productSerial = productSerial;
    _storeName = storeName;
    _vendorName = vendorName;
    _quantity = quantity;
    _price = price;
    _discount = discount;
    _total = total;
    _approved = approved;
  }

  OrderDetails.fromJson(dynamic json) {
    _id = json["id"];
    _orderId = json["order_id"];
    _productId = json["product_id"];
    _storeId = json["store_id"];
    _vendorId = json["vendor_id"];
    _productName = json["product_name"];
    _productSerial = json["product_serial"];
    _storeName = json["store_name"];
    _vendorName = json["vendor_name"];
    _quantity = json["quantity"];
    _price = json["price"];
    _discount = json["discount"];
    _total = json["total"].toString();
    _approved = json["approved"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["order_id"] = _orderId;
    map["product_id"] = _productId;
    map["store_id"] = _storeId;
    map["vendor_id"] = _vendorId;
    map["product_name"] = _productName;
    map["product_serial"] = _productSerial;
    map["store_name"] = _storeName;
    map["vendor_name"] = _vendorName;
    map["quantity"] = _quantity;
    map["price"] = _price;
    map["discount"] = _discount;
    map["total"] = _total;
    map["approved"] = _approved;
    return map;
  }
}
