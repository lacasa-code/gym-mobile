/// status_code : 200
/// message : "success"
/// data : [{"id":3,"main_category_name":"الاجزاء الداخلية و الخارجية","status":1,"lang":"ar"}]

class Main_category {
  int _statusCode;
  String _message;
  List<Main_Category> _data;

  int get statusCode => _statusCode;
  String get message => _message;
  List<Main_Category> get data => _data;

  Main_category({
      int statusCode, 
      String message, 
      List<Main_Category> data}){
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  Main_category.fromJson(dynamic json) {
    _statusCode = json["status_code"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Main_Category.fromJson(v));
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

/// id : 3
/// main_category_name : "الاجزاء الداخلية و الخارجية"
/// status : 1
/// lang : "ar"

class Main_Category {
  int _id;
  String _mainCategoryName;
  int _status;
  String _lang;

  int get id => _id;
  String get mainCategoryName => _mainCategoryName;
  int get status => _status;
  String get lang => _lang;

  Main_Category({
      int id, 
      String mainCategoryName, 
      int status, 
      String lang}){
    _id = id;
    _mainCategoryName = mainCategoryName;
    _status = status;
    _lang = lang;
}

  Main_Category.fromJson(dynamic json) {
    _id = json["id"];
    _mainCategoryName = json["main_category_name"];
    _status = json["status"];
    _lang = json["lang"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["main_category_name"] = _mainCategoryName;
    map["status"] = _status;
    map["lang"] = _lang;
    return map;
  }

}