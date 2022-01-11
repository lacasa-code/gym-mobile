/// data : [{"id":1,"title":"first service item","short_description":"sdsd","type":"Service","status":"Active","created_at":"Tuesday 4th January 2022 08:26:50 am","updated_at":"Sunday 9th January 2022 05:46:45 pm","itemSlots":[{"id":1,"title":"first item first slot","slot_frequency":1,"slot_duration_minutes":2321,"slot_time":"10:24:00 am","status":"Active","created_at":"2022-01-04 08:26:50","updated_at":"2022-01-04 08:26:50"}]},{"id":2,"title":"AAA","short_description":"AAA description","type":"Service","status":"Active","created_at":"Thursday 6th January 2022 01:48:19 pm","updated_at":"Sunday 9th January 2022 04:55:34 pm","itemSlots":[]},{"id":3,"title":"yahh","short_description":"Yahhhhhhh","type":"Service","status":"Active","created_at":"Thursday 6th January 2022 01:52:47 pm","updated_at":"Thursday 6th January 2022 01:52:47 pm","itemSlots":[{"id":2,"title":"yahh slot","slot_frequency":1,"slot_duration_minutes":30,"slot_time":"03:51:00 am","status":"Active","created_at":"2022-01-06 13:52:47","updated_at":"2022-01-06 13:52:47"}]},{"id":4,"title":"first","short_description":"vvvvvvvvvvvvv","type":"Service","status":"Active","created_at":"Sunday 9th January 2022 11:25:59 am","updated_at":"Sunday 9th January 2022 04:56:31 pm","itemSlots":[]}]
/// status_code : 200

class Item_model {
  Item_model({
      List<Item> data,
      int statusCode,}){
    _data = data;
    _statusCode = statusCode;
}

  Item_model.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Item.fromJson(v));
      });
    }
    _statusCode = json['status_code'];
  }
  List<Item> _data;
  int _statusCode;

  List<Item> get data => _data;
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

/// id : 1
/// title : "first service item"
/// short_description : "sdsd"
/// type : "Service"
/// status : "Active"
/// created_at : "Tuesday 4th January 2022 08:26:50 am"
/// updated_at : "Sunday 9th January 2022 05:46:45 pm"
/// itemSlots : [{"id":1,"title":"first item first slot","slot_frequency":1,"slot_duration_minutes":2321,"slot_time":"10:24:00 am","status":"Active","created_at":"2022-01-04 08:26:50","updated_at":"2022-01-04 08:26:50"}]

class Item {
  Item({
      int id, 
      String title, 
      String shortDescription, 
      String type, 
      String status, 
      String createdAt, 
      String updatedAt, 
      List<ItemSlots> itemSlots,}){
    _id = id;
    _title = title;
    _shortDescription = shortDescription;
    _type = type;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _itemSlots = itemSlots;
}

  Item.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _shortDescription = json['short_description'];
    _type = json['type'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['itemSlots'] != null) {
      _itemSlots = [];
      json['itemSlots'].forEach((v) {
        _itemSlots.add(ItemSlots.fromJson(v));
      });
    }
  }
  int _id;
  String _title;
  String _shortDescription;
  String _type;
  String _status;
  String _createdAt;
  String _updatedAt;
  List<ItemSlots> _itemSlots;

  set id(int value) {
    _id = value;
  }

  int get id => _id;
  String get title => _title;
  String get shortDescription => _shortDescription;
  String get type => _type;
  String get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  List<ItemSlots> get itemSlots => _itemSlots;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['short_description'] = _shortDescription;
    map['type'] = _type;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_itemSlots != null) {
      map['itemSlots'] = _itemSlots.map((v) => v.toJson()).toList();
    }
    return map;
  }

  set title(String value) {
    _title = value;
  }

  set shortDescription(String value) {
    _shortDescription = value;
  }

  set type(String value) {
    _type = value;
  }

  set status(String value) {
    _status = value;
  }

  set createdAt(String value) {
    _createdAt = value;
  }

  set updatedAt(String value) {
    _updatedAt = value;
  }

  set itemSlots(List<ItemSlots> value) {
    _itemSlots = value;
  }
}

/// id : 1
/// title : "first item first slot"
/// slot_frequency : 1
/// slot_duration_minutes : 2321
/// slot_time : "10:24:00 am"
/// status : "Active"
/// created_at : "2022-01-04 08:26:50"
/// updated_at : "2022-01-04 08:26:50"

class ItemSlots {
  ItemSlots({
      int id, 
      String title, 
      int slotFrequency, 
      int slotDurationMinutes, 
      String slotTime, 
      String status, 
      String createdAt, 
      String updatedAt,}){
    _id = id;
    _title = title;
    _slotFrequency = slotFrequency;
    _slotDurationMinutes = slotDurationMinutes;
    _slotTime = slotTime;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  ItemSlots.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _slotFrequency = json['slot_frequency'];
    _slotDurationMinutes = json['slot_duration_minutes'];
    _slotTime = json['slot_time'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  int _id;
  String _title;
  int _slotFrequency;
  int _slotDurationMinutes;
  String _slotTime;
  String _status;
  String _createdAt;
  String _updatedAt;

  int get id => _id;
  String get title => _title;
  int get slotFrequency => _slotFrequency;
  int get slotDurationMinutes => _slotDurationMinutes;
  String get slotTime => _slotTime;
  String get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['slot_frequency'] = _slotFrequency;
    map['slot_duration_minutes'] = _slotDurationMinutes;
    map['slot_time'] = _slotTime;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}