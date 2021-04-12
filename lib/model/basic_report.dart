/// total_orders : 12
/// total_invoices : 14
/// total_sale : 18339.8
/// total_customers : 9
/// total_vendors : 4
/// total_products : 5
/// period_details : [{"day":"2021-03-09","day_name":"Tuesday","reports":{"total_sale":16339.8}},{"day":"2021-03-15","day_name":"Monday","reports":{"total_sale":2000}}]

class Basic_report {
  int _totalOrders;
  int _totalInvoices;
  double _totalSale;
  int _totalCustomers;
  int _totalVendors;
  int _totalProducts;
  List<Period_details> _periodDetails;

  int get totalOrders => _totalOrders;
  int get totalInvoices => _totalInvoices;
  double get totalSale => _totalSale;
  int get totalCustomers => _totalCustomers;
  int get totalVendors => _totalVendors;
  int get totalProducts => _totalProducts;
  List<Period_details> get periodDetails => _periodDetails;

  Basic_report(
      {int totalOrders,
      int totalInvoices,
      double totalSale,
      int totalCustomers,
      int totalVendors,
      int totalProducts,
      List<Period_details> periodDetails}) {
    _totalOrders = totalOrders;
    _totalInvoices = totalInvoices;
    _totalSale = totalSale;
    _totalCustomers = totalCustomers;
    _totalVendors = totalVendors;
    _totalProducts = totalProducts;
    _periodDetails = periodDetails;
  }

  Basic_report.fromJson(dynamic json) {
    _totalOrders = json["total_orders"];
    _totalInvoices = json["total_invoices"];
    _totalSale = double.parse(json["total_sale"].toString());
    _totalCustomers = json["total_customers"];
    _totalVendors = json["total_vendors"];
    _totalProducts = json["total_products"];
    if (json["period_details"] != null) {
      _periodDetails = [];
      json["period_details"].forEach((v) {
        _periodDetails.add(Period_details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["total_orders"] = _totalOrders;
    map["total_invoices"] = _totalInvoices;
    map["total_sale"] = _totalSale;
    map["total_customers"] = _totalCustomers;
    map["total_vendors"] = _totalVendors;
    map["total_products"] = _totalProducts;
    if (_periodDetails != null) {
      map["period_details"] = _periodDetails.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// day : "2021-03-09"
/// day_name : "Tuesday"
/// reports : {"total_sale":16339.8}

class Period_details {
  String _day;
  String _dayName;
  Reports _reports;

  String get day => _day;
  String get dayName => _dayName;
  Reports get reports => _reports;

  Period_details({String day, String dayName, Reports reports}) {
    _day = day;
    _dayName = dayName;
    _reports = reports;
  }

  Period_details.fromJson(dynamic json) {
    _day = json["day"];
    _dayName = json["day_name"];
    _reports =
        json["reports"] != null ? Reports.fromJson(json["reports"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["day"] = _day;
    map["day_name"] = _dayName;
    if (_reports != null) {
      map["reports"] = _reports.toJson();
    }
    return map;
  }
}

/// total_sale : 16339.8

class Reports {
  double _totalSale;

  double get totalSale => _totalSale;

  Reports({double totalSale}) {
    _totalSale = totalSale;
  }

  Reports.fromJson(dynamic json) {
    _totalSale = double.parse(json["total_sale"].toString());
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["total_sale"] = _totalSale;
    return map;
  }
}
