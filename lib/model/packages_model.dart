/// data : [{"id":16,"title":"Apex1","short_description":"nnnnnnnnnnn","status":"Active","created_at":"Sunday 9th January 2022 11:39:19 am","updated_at":"Sunday 9th January 2022 11:40:03 am","package_items":[{"id":3,"status":"1","packages__id":"16","items__id":"1","item":{"id":1,"title":"first service item"}},{"id":5,"status":"1","packages__id":"16","items__id":"3","item":{"id":3,"title":"yahh"}},{"id":6,"status":"1","packages__id":"16","items__id":"2","item":{"id":2,"title":"AAA"}},{"id":7,"status":"1","packages__id":"16","items__id":"4","item":{"id":4,"title":"first"}}],"package_prices":[{"id":1,"price":10,"frequency":"1","status":"Active"},{"id":2,"price":60,"frequency":"6","status":"Active"}]},{"id":17,"title":"Apex2","short_description":"bbbbbbbbb","status":"Active","created_at":"Sunday 9th January 2022 11:42:58 am","updated_at":"Monday 10th January 2022 06:40:27 pm","package_items":[{"id":9,"status":"1","packages__id":"17","items__id":"3","item":{"id":3,"title":"yahh"}},{"id":10,"status":"1","packages__id":"17","items__id":"2","item":{"id":2,"title":"AAA"}},{"id":11,"status":"1","packages__id":"17","items__id":"4","item":{"id":4,"title":"first"}},{"id":15,"status":"1","packages__id":"17","items__id":"1","item":{"id":1,"title":"first service item"}}],"package_prices":[{"id":3,"price":10,"frequency":"1","status":"Active"},{"id":4,"price":20,"frequency":"2","status":"Active"},{"id":5,"price":30,"frequency":"3","status":"Active"},{"id":6,"price":40,"frequency":"4","status":"Active"},{"id":7,"price":50,"frequency":"5","status":"Active"},{"id":8,"price":60,"frequency":"6","status":"Active"}]},{"id":18,"title":"Apex3","short_description":"bbbbbnnnnn","status":"Active","created_at":"Sunday 9th January 2022 12:52:30 pm","updated_at":"Sunday 9th January 2022 12:52:30 pm","package_items":[{"id":12,"status":"1","packages__id":"18","items__id":"1","item":{"id":1,"title":"first service item"}},{"id":13,"status":"1","packages__id":"18","items__id":"2","item":{"id":2,"title":"AAA"}}],"package_prices":[{"id":9,"price":10,"frequency":"1","status":"Active"},{"id":10,"price":30,"frequency":"3","status":"Active"},{"id":11,"price":80,"frequency":"6","status":"Active"}]},{"id":19,"title":"Vendor","short_description":"bbbbbbbbbb","status":"Active","created_at":"Sunday 9th January 2022 01:04:13 pm","updated_at":"Sunday 9th January 2022 01:04:13 pm","package_items":[{"id":14,"status":"1","packages__id":"19","items__id":"1","item":{"id":1,"title":"first service item"}}],"package_prices":[{"id":12,"price":0,"frequency":"1","status":"Active"}]}]
/// status_code : 200

class Packages_model {
  Packages_model({
      List<Package> data,
      int statusCode,}){
    _data = data;
    _statusCode = statusCode;
}

  Packages_model.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Package.fromJson(v));
      });
    }
    _statusCode = json['status_code'];
  }
  List<Package> _data;
  int _statusCode;

  List<Package> get data => _data;
  int get statusCode => _statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data.map((v) => v.toJson()).toList();
    }
    map['status_code'] = _statusCode;
    return map;
  }

}

/// id : 16
/// title : "Apex1"
/// short_description : "nnnnnnnnnnn"
/// status : "Active"
/// created_at : "Sunday 9th January 2022 11:39:19 am"
/// updated_at : "Sunday 9th January 2022 11:40:03 am"
/// package_items : [{"id":3,"status":"1","packages__id":"16","items__id":"1","item":{"id":1,"title":"first service item"}},{"id":5,"status":"1","packages__id":"16","items__id":"3","item":{"id":3,"title":"yahh"}},{"id":6,"status":"1","packages__id":"16","items__id":"2","item":{"id":2,"title":"AAA"}},{"id":7,"status":"1","packages__id":"16","items__id":"4","item":{"id":4,"title":"first"}}]
/// package_prices : [{"id":1,"price":10,"frequency":"1","status":"Active"},{"id":2,"price":60,"frequency":"6","status":"Active"}]

class Package {
  Package({
      int id, 
      String title, 
      String shortDescription, 
      String status, 
      String createdAt, 
      String updatedAt, 
      List<Package_items> packageItems, 
      List<Package_prices> packagePrices,}){
    _id = id;
    _title = title;
    _shortDescription = shortDescription;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _packageItems = packageItems;
    _packagePrices = packagePrices;
}

  Package.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _shortDescription = json['short_description'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['package_items'] != null) {
      _packageItems = [];
      json['package_items'].forEach((v) {
        _packageItems.add(Package_items.fromJson(v));
      });
    }
    if (json['package_prices'] != null) {
      _packagePrices = [];
      json['package_prices'].forEach((v) {
        _packagePrices.add(Package_prices.fromJson(v));
      });
    }
  }
  int _id;
  String _title;
  String _shortDescription;
  String _status;
  String _createdAt;
  String _updatedAt;
  List<Package_items> _packageItems;
  List<Package_prices> _packagePrices;

  int get id => _id;
  String get title => _title;
  String get shortDescription => _shortDescription;
  String get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  List<Package_items> get packageItems => _packageItems;
  List<Package_prices> get packagePrices => _packagePrices;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['short_description'] = _shortDescription;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_packageItems != null) {
      map['package_items'] = _packageItems.map((v) => v.toJson()).toList();
    }
    if (_packagePrices != null) {
      map['package_prices'] = _packagePrices.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// price : 10
/// frequency : "1"
/// status : "Active"

class Package_prices {
  Package_prices({
      int id, 
      int price, 
      String frequency, 
      String status,}){
    _id = id;
    _price = price;
    _frequency = frequency;
    _status = status;
}

  Package_prices.fromJson(dynamic json) {
    _id = json['id'];
    _price = json['price'];
    _frequency = json['frequency'];
    _status = json['status'];
  }
  int _id;
  int _price;
  String _frequency;
  String _status;

  int get id => _id;
  int get price => _price;
  String get frequency => _frequency;
  String get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['price'] = _price;
    map['frequency'] = _frequency;
    map['status'] = _status;
    return map;
  }

}

/// id : 3
/// status : "1"
/// packages__id : "16"
/// items__id : "1"
/// item : {"id":1,"title":"first service item"}

class Package_items {
  Package_items({
      int id, 
      String status, 
      String packagesId, 
      String itemsId, 
      Item item,}){
    _id = id;
    _status = status;
    _packagesId = packagesId;
    _itemsId = itemsId;
    _item = item;
}

  Package_items.fromJson(dynamic json) {
    _id = json['id'];
    _status = json['status'];
    _packagesId = json['packages__id'];
    _itemsId = json['items__id'];
    _item = json['item'] != null ? Item.fromJson(json['item']) : null;
  }
  int _id;
  String _status;
  String _packagesId;
  String _itemsId;
  Item _item;

  int get id => _id;
  String get status => _status;
  String get packagesId => _packagesId;
  String get itemsId => _itemsId;
  Item get item => _item;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['status'] = _status;
    map['packages__id'] = _packagesId;
    map['items__id'] = _itemsId;
    if (_item != null) {
      map['item'] = _item.toJson();
    }
    return map;
  }

}

/// id : 1
/// title : "first service item"

class Item {
  Item({
      int id, 
      String title,}){
    _id = id;
    _title = title;
}

  Item.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
  }
  int _id;
  String _title;

  int get id => _id;
  String get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    return map;
  }

}