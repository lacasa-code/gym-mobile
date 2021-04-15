/// status_code : 200
/// message : "success"
/// data : [{"id":1,"year":"2011"}]

class Years {
  int _statusCode;
  String _message;
  List<Year> _data;

  int get statusCode => _statusCode;
  String get message => _message;
  List<Year> get data => _data;

  Years({
      int statusCode, 
      String message, 
      List<Year> data}){
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  Years.fromJson(dynamic json) {
    _statusCode = json["status_code"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Year.fromJson(v));
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
/// year : "2011"

class Year {
  int _id;
  String _year;

  int get id => _id;
  String get year => _year;

  Year({
      int id, 
      String year}){
    _id = id;
    _year = year;
}

  Year.fromJson(dynamic json) {
    _id = json["id"];
    _year = json["year"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["year"] = _year;
    return map;
  }

}