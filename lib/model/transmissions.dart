/// status_code : 200
/// message : "success"
/// data : [{"id":1,"transmission_name":"manual"},{"id":2,"transmission_name":"automatic"}]

class Transmissions {
  int _statusCode;
  String _message;
  List<Transmission> _data;

  int get statusCode => _statusCode;
  String get message => _message;
  List<Transmission> get data => _data;

  Transmissions({int statusCode, String message, List<Transmission> data}) {
    _statusCode = statusCode;
    _message = message;
    _data = data;
  }

  Transmissions.fromJson(dynamic json) {
    _statusCode = json["status_code"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Transmission.fromJson(v));
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
/// transmission_name : "manual"

class Transmission {
  int _id;
  String _transmissionName;

  int get id => _id;
  String get transmissionName => _transmissionName;

  Transmission({int id, String transmissionName}) {
    _id = id;
    _transmissionName = transmissionName;
  }

  Transmission.fromJson(dynamic json) {
    _id = json["id"];
    _transmissionName = json["transmission_name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["transmission_name"] = _transmissionName;
    return map;
  }
}
