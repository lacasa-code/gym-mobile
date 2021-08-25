/// status_code : 200
/// message : "success"
/// data : [{"id":1,"country_name":"Germany","country_code":"DE","status":1}]

class ProdCountry_model {
  int _statusCode;
  String _message;
  List<ProdCountry> _data;

  int get statusCode => _statusCode;
  String get message => _message;
  List<ProdCountry> get data => _data;

  ProdCountry_model({
      int statusCode, 
      String message, 
      List<ProdCountry> data}){
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  ProdCountry_model.fromJson(dynamic json) {
    _statusCode = json["status_code"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(ProdCountry.fromJson(v));
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
/// country_name : "Germany"
/// country_code : "DE"
/// status : 1

class ProdCountry {
  int _id;
  String _countryName;
  String _name_en;
  String _countryCode;
  int _status;

  int get id => _id;
  String get countryName => _countryName;
  String get countryCode => _countryCode;
  String get name_en =>_name_en;
  int get status => _status;

  ProdCountry({
      int id, 
      String countryName, 
      String countryCode, 
      int status}){
    _id = id;
    _countryName = countryName;
    _name_en = name_en;
    _countryCode = countryCode;
    _status = status;
}

  ProdCountry.fromJson(dynamic json) {
    _id = json["id"];
    _countryName = json["country_name"];
    _countryCode = json["country_code"];
    _name_en = json["name_en"];
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["country_name"] = _countryName;
    map["country_code"] = _countryCode;
    map["status"] = _status;
    return map;
  }

}