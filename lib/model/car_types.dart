/// status_code : 200
/// message : "success"
/// data : [{"id":1,"type_name":"سيارات ركوب A","lang":"ar","status":1,"created_at":"2021-05-10 07:33:11","updated_at":"2021-05-10 07:34:34","some_image":"https://traker.fra1.digitaloceanspaces.com/products/JAEbglSyneWFDwambrvrXHMg1nRsKQDzJq50nrrj.png"},{"id":3,"type_name":"bike","lang":"ar","status":1,"created_at":"2021-05-10 07:33:11","updated_at":"2021-05-10 07:33:11","some_image":"https://traker.fra1.digitaloceanspaces.com/products/IypOLu8ZqZPeFBglGuq9V1ivPL5vASl6Ri9TPcVA.png"}]

class CarTypes {
  int _statusCode;
  String _message;
  List<CarType> _data;

  int get statusCode => _statusCode;
  String get message => _message;
  List<CarType> get data => _data;

  CarTypes({
      int statusCode, 
      String message, 
      List<CarType> data}){
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  CarTypes.fromJson(dynamic json) {
    _statusCode = json["status_code"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(CarType.fromJson(v));
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
/// type_name : "سيارات ركوب A"
/// lang : "ar"
/// status : 1
/// created_at : "2021-05-10 07:33:11"
/// updated_at : "2021-05-10 07:34:34"
/// some_image : "https://traker.fra1.digitaloceanspaces.com/products/JAEbglSyneWFDwambrvrXHMg1nRsKQDzJq50nrrj.png"

class CarType {
  int _id;
  String _typeName;
  String _name_en;
  String _lang;
  int _status;
  String _createdAt;
  String _updatedAt;
  String _someImage;

  int get id => _id;
  String get typeName => _typeName;
  String get name_en => _name_en;
  String get lang => _lang;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get someImage => _someImage;

  CarType({
      int id, 
      String typeName, 
      String lang, 
      int status, 
      String createdAt, 
      String updatedAt, 
      String someImage}){
    _id = id;
    _typeName = typeName;
    _name_en =  name_en;
    _lang = lang;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _someImage = someImage;
}

  CarType.fromJson(dynamic json) {
    _id = json["id"];
    _typeName = json["type_name"];
    _name_en = json["name_en"];
    _lang = json["lang"];
    _status = json["status"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    _someImage = json["some_image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["type_name"] = _typeName;
    map["lang"] = _lang;
    map["status"] = _status;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    map["some_image"] = _someImage;
    return map;
  }

}