/// status_code : 200
/// message : "success"
/// data : [{"id":6,"area_name":"المنطقه الشرقيه","country_id":187,"status":1,"lang":"ar","created_at":"2021-06-23 08:00:08","updated_at":"2021-06-23 08:00:08","deleted_at":null}]

class Area_model {
  int _statusCode;
  String _message;
  List<Area> _data;

  int get statusCode => _statusCode;
  String get message => _message;
  List<Area> get data => _data;

  Area_model({
      int statusCode, 
      String message, 
      List<Area> data}){
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  Area_model.fromJson(dynamic json) {
    _statusCode = json["status_code"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Area.fromJson(v));
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

/// id : 6
/// area_name : "المنطقه الشرقيه"
/// country_id : 187
/// status : 1
/// lang : "ar"
/// created_at : "2021-06-23 08:00:08"
/// updated_at : "2021-06-23 08:00:08"
/// deleted_at : null

class Area {
  int _id;
  String _areaName;
  int _countryId;
  String _name_en;

  int _status;
  String _lang;
  String _createdAt;
  String _updatedAt;
  dynamic _deletedAt;

  int get id => _id;
  String get name_en => _name_en;

  String get areaName => _areaName;
  int get countryId => _countryId;
  int get status => _status;
  String get lang => _lang;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;

  Area({
      int id, 
      String areaName, 
      int countryId, 
      int status, 
      String lang, 
      String createdAt, 
      String updatedAt, 
      dynamic deletedAt}){
    _id = id;
    _areaName = areaName;
    _countryId = countryId;
    _status = status;
    _lang = lang;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
}

  Area.fromJson(dynamic json) {
    _id = json["id"];
    _name_en = json["name_en"];
    _areaName = json["area_name"];
    _countryId = json["country_id"];
    _status = json["status"];
    _lang = json["lang"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    _deletedAt = json["deleted_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["area_name"] = _areaName;
    map["country_id"] = _countryId;
    map["status"] = _status;
    map["lang"] = _lang;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    map["deleted_at"] = _deletedAt;
    return map;
  }

}