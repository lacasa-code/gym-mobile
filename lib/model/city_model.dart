/// status_code : 200
/// message : "success"
/// data : [{"id":6,"city_name":"جده","area_id":6,"country_id":187,"status":1,"lang":"ar","created_at":"2021-06-23 08:00:20","updated_at":"2021-06-23 08:00:20","deleted_at":null}]

class City_model {
  int _statusCode;
  String _message;
  List<City> _data;

  int get statusCode => _statusCode;
  String get message => _message;
  List<City> get data => _data;

  City_model({
      int statusCode, 
      String message, 
      List<City> data}){
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  City_model.fromJson(dynamic json) {
    _statusCode = json["status_code"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(City.fromJson(v));
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
/// city_name : "جده"
/// area_id : 6
/// country_id : 187
/// status : 1
/// lang : "ar"
/// created_at : "2021-06-23 08:00:20"
/// updated_at : "2021-06-23 08:00:20"
/// deleted_at : null

class City {
  int _id;
  String _cityName;
  int _areaId;
  int _countryId;
  int _status;
  String _lang;
  String _createdAt;
  String _updatedAt;
  dynamic _deletedAt;

  int get id => _id;
  String get cityName => _cityName;
  int get areaId => _areaId;
  int get countryId => _countryId;
  int get status => _status;
  String get lang => _lang;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;

  City({
      int id, 
      String cityName, 
      int areaId, 
      int countryId, 
      int status, 
      String lang, 
      String createdAt, 
      String updatedAt, 
      dynamic deletedAt}){
    _id = id;
    _cityName = cityName;
    _areaId = areaId;
    _countryId = countryId;
    _status = status;
    _lang = lang;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
}

  City.fromJson(dynamic json) {
    _id = json["id"];
    _cityName = json["city_name"];
    _areaId = json["area_id"];
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
    map["city_name"] = _cityName;
    map["area_id"] = _areaId;
    map["country_id"] = _countryId;
    map["status"] = _status;
    map["lang"] = _lang;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    map["deleted_at"] = _deletedAt;
    return map;
  }

}