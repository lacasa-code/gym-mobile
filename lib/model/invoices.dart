/// data : [{"id":1,"order_id":1,"order_number":20000000,"vendor_id":1,"vendor_name":"first vendor","vendor_email":"vendor@vendor.com","invoice_number":40000000,"invoice_total":19.8,"status":1,"created_at":"2021-03-09T09:34:21.000000Z","time_created":"2021-03-09 09:34:21"},{"id":2,"order_id":5,"order_number":20000004,"vendor_id":2,"vendor_name":"second  vendor","vendor_email":"second@second.com","invoice_number":40000001,"invoice_total":40,"status":1,"created_at":"2021-03-09T09:34:22.000000Z","time_created":"2021-03-09 09:34:22"},{"id":3,"order_id":5,"order_number":20000004,"vendor_id":3,"vendor_name":"third vendor","vendor_email":"thirdv@v.com","invoice_number":40000002,"invoice_total":10,"status":1,"created_at":"2021-03-09T09:34:23.000000Z","time_created":"2021-03-09 09:34:23"},{"id":4,"order_id":2,"order_number":20000001,"vendor_id":2,"vendor_name":"second  vendor","vendor_email":"second@second.com","invoice_number":40000003,"invoice_total":110,"status":1,"created_at":"2021-03-09T09:34:24.000000Z","time_created":"2021-03-09 09:34:24"},{"id":5,"order_id":3,"order_number":20000002,"vendor_id":2,"vendor_name":"second  vendor","vendor_email":"second@second.com","invoice_number":40000004,"invoice_total":280,"status":1,"created_at":"2021-03-09T09:34:25.000000Z","time_created":"2021-03-09 09:34:25"},{"id":6,"order_id":4,"order_number":20000003,"vendor_id":3,"vendor_name":"third vendor","vendor_email":"thirdv@v.com","invoice_number":40000005,"invoice_total":250,"status":1,"created_at":"2021-03-09T09:34:26.000000Z","time_created":"2021-03-09 09:34:26"},{"id":7,"order_id":6,"order_number":20000005,"vendor_id":2,"vendor_name":"second  vendor","vendor_email":"second@second.com","invoice_number":40000006,"invoice_total":90,"status":1,"created_at":"2021-03-09T09:34:27.000000Z","time_created":"2021-03-09 09:34:27"},{"id":8,"order_id":6,"order_number":20000005,"vendor_id":3,"vendor_name":"third vendor","vendor_email":"thirdv@v.com","invoice_number":40000007,"invoice_total":160,"status":1,"created_at":"2021-03-09T09:34:28.000000Z","time_created":"2021-03-09 09:34:28"},{"id":9,"order_id":7,"order_number":20000006,"vendor_id":2,"vendor_name":"second  vendor","vendor_email":"second@second.com","invoice_number":40000008,"invoice_total":80,"status":1,"created_at":"2021-03-09T09:34:29.000000Z","time_created":"2021-03-09 09:34:29"},{"id":10,"order_id":8,"order_number":20000007,"vendor_id":2,"vendor_name":"second  vendor","vendor_email":"second@second.com","invoice_number":40000009,"invoice_total":300,"status":1,"created_at":"2021-03-09T09:34:30.000000Z","time_created":"2021-03-09 09:34:30"}]
/// total : 14

class Invoices_model {
  List<Invoice> _data;
  int _total;

  List<Invoice> get data => _data;
  int get total => _total;

  Invoices_model({List<Invoice> data, int total}) {
    _data = data;
    _total = total;
  }

  Invoices_model.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Invoice.fromJson(v));
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
/// order_id : 1
/// order_number : 20000000
/// vendor_id : 1
/// vendor_name : "first vendor"
/// vendor_email : "vendor@vendor.com"
/// invoice_number : 40000000
/// invoice_total : 19.8
/// status : 1
/// created_at : "2021-03-09T09:34:21.000000Z"
/// time_created : "2021-03-09 09:34:21"

class Invoice {
  int _id;
  int _orderId;
  int _orderNumber;
  int _vendorId;
  String _vendorName;
  String _vendorEmail;
  int _invoiceNumber;
  String _invoiceTotal;
  int _status;
  String _createdAt;
  String _timeCreated;

  int get id => _id;
  int get orderId => _orderId;
  int get orderNumber => _orderNumber;
  int get vendorId => _vendorId;
  String get vendorName => _vendorName;
  String get vendorEmail => _vendorEmail;
  int get invoiceNumber => _invoiceNumber;
  String get invoiceTotal => _invoiceTotal;
  int get status => _status;
  String get createdAt => _createdAt;
  String get timeCreated => _timeCreated;

  Invoice(
      {int id,
      int orderId,
      int orderNumber,
      int vendorId,
      String vendorName,
      String vendorEmail,
      int invoiceNumber,
      String invoiceTotal,
      int status,
      String createdAt,
      String timeCreated}) {
    _id = id;
    _orderId = orderId;
    _orderNumber = orderNumber;
    _vendorId = vendorId;
    _vendorName = vendorName;
    _vendorEmail = vendorEmail;
    _invoiceNumber = invoiceNumber;
    _invoiceTotal = invoiceTotal;
    _status = status;
    _createdAt = createdAt;
    _timeCreated = timeCreated;
  }

  Invoice.fromJson(dynamic json) {
    _id = json["id"];
    _orderId = json["order_id"];
    _orderNumber = json["order_number"];
    _vendorId = json["vendor_id"];
    _vendorName = json["vendor_name"];
    _vendorEmail = json["vendor_email"];
    _invoiceNumber = json["invoice_number"];
    _invoiceTotal = json["invoice_total"].toString();
    _status = json["status"];
    _createdAt = json["created_at"];
    _timeCreated = json["time_created"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["order_id"] = _orderId;
    map["order_number"] = _orderNumber;
    map["vendor_id"] = _vendorId;
    map["vendor_name"] = _vendorName;
    map["vendor_email"] = _vendorEmail;
    map["invoice_number"] = _invoiceNumber;
    map["invoice_total"] = _invoiceTotal;
    map["status"] = _status;
    map["created_at"] = _createdAt;
    map["time_created"] = _timeCreated;
    return map;
  }
}
