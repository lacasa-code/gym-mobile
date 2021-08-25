/// status_code : 200
/// message : "success"
/// data : [{"id":1,"manufacturer_name":"BOSCH","status":1},{"id":2,"manufacturer_name":"AFC","status":1},{"id":3,"manufacturer_name":"GED","status":1}]

class Manufacturer_model {
  int _statusCode;
  String _message;
  List<Manufacturer> _data;

  int get statusCode => _statusCode;
  String get message => _message;
  List<Manufacturer> get data => _data;

  Manufacturer_model({
      int statusCode, 
      String message, 
      List<Manufacturer> data}){
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  Manufacturer_model.fromJson(dynamic json) {
    _statusCode = json["status_code"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Manufacturer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status_code"] = _statusCode;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// manufacturer_name : "BOSCH"
/// status : 1

class Manufacturer {
  int _id;
  String _manufacturerName;
  String _name_en;
  int _status;

  int get id => _id;
  String get manufacturerName => _manufacturerName;
  String get name_en => _name_en;
  int get status => _status;

  Manufacturer({
      int id, 
      String manufacturerName, 
      int status}){
    _id = id;
    _manufacturerName = manufacturerName;
    _name_en = name_en;
    _status = status;
}

  Manufacturer.fromJson(dynamic json) {
    _id = json["id"];
    _manufacturerName = json["manufacturer_name"];
    _name_en = json["name_en"];
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["manufacturer_name"] = _manufacturerName;
    map["status"] = _status;
    return map;
  }

}