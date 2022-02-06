class Dashboard_model {
  Dashboard_model({
      this.data, 
      this.statusCode,});

  Dashboard_model.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Dashboard.fromJson(v));
      });
    }
    statusCode = json['status_code'];
  }
  List<Dashboard> data;
  int statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['status_code'] = statusCode;
    return map;
  }

}

class Dashboard {
  Dashboard({
      this.countItems, 
      this.activeItems, 
      this.countPackages, 
      this.purchasedItems, 
      this.countCustomers, 
      this.activeCustomers, 
      this.countTransactions, 
      this.creditAmount, 
      this.dabitAmount, 
      this.overdueBills,});

  Dashboard.fromJson(dynamic json) {
    countItems = json['count_items'];
    activeItems = json['active_items'];
    countPackages = json['count_packages'];
    purchasedItems = json['purchased_items'];
    countCustomers = json['count_customers'];
    activeCustomers = json['active_customers'];
    countTransactions = json['count_transactions'];
    creditAmount = json['creditAmount'];
    dabitAmount = json['dabitAmount'];
    overdueBills = json['overdue_bills'];
  }
  int countItems;
  int activeItems;
  int countPackages;
  int purchasedItems;
  int countCustomers;
  int activeCustomers;
  int countTransactions;
  String creditAmount;
  String dabitAmount;
  int overdueBills;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count_items'] = countItems;
    map['active_items'] = activeItems;
    map['count_packages'] = countPackages;
    map['purchased_items'] = purchasedItems;
    map['count_customers'] = countCustomers;
    map['active_customers'] = activeCustomers;
    map['count_transactions'] = countTransactions;
    map['creditAmount'] = creditAmount;
    map['dabitAmount'] = dabitAmount;
    map['overdue_bills'] = overdueBills;
    return map;
  }

}