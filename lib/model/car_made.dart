/// status_code : 200
/// message : "success"
/// data : [{"id":2,"car_made":"BMW2","categoryid_id":1,"catName":"first categoryEdit Category Name"}]
/// total : 4

class CarsMade {
  int _statusCode;
  String _message;
  List<CarMade> _data;
  int _total;

  int get statusCode => _statusCode;
  String get message => _message;
  List<CarMade> get data => _data;
  int get total => _total;

  CarsMade({
      int statusCode, 
      String message, 
      List<CarMade> data,
      int total}){
    _statusCode = statusCode;
    _message = message;
    _data = data;
    _total = total;
}

  CarsMade.fromJson(dynamic json) {
    _statusCode = json["status_code"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(CarMade.fromJson(v));
      });
    }
    _total = json["total"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status_code"] = _statusCode;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    map["total"] = _total;
    return map;
  }

}

/// id : 2
/// car_made : "BMW2"
/// categoryid_id : 1
/// catName : "first categoryEdit Category Name"

class CarMade {
  String _id;
  String _carMade;
  int _categoryidId;
  String _catName;

  String get id => _id;
  String get carMade => _carMade;
  int get categoryidId => _categoryidId;
  String get catName => _catName;

  CarMade({
    String id,
      String carMade, 
      int categoryidId, 
      String catName}){
    _id = id;
    _carMade = carMade;
    _categoryidId = categoryidId;
    _catName = catName;
}

  CarMade.fromJson(dynamic json) {
    _id = json["id"].toString();
    _carMade = json["car_made"];
    _categoryidId = json["categoryid_id"];
    _catName = json["catName"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["car_made"] = _carMade;
    map["categoryid_id"] = _categoryidId;
    map["catName"] = _catName;
    return map;
  }

}