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
  int _allcategory_id;
  String name;
  String name_en;
  int _status;
  List<Main_Category> categories;

  int get id => _id;
  int get allcategory_id => _allcategory_id;
  String get mainCategoryName => name;
  String get mainCategoryNameen => name_en;
  int get status => _status;
  List<Main_Category> get Categories => categories;

  Main_Category({
      int id, 
      int allcategory_id,
      String mainCategoryName,
      String mainCategoryNameen,
      int status,
    List<Main_Category> lang}){
    _id = id;
    _allcategory_id = allcategory_id;
    name = mainCategoryName;
    name_en = mainCategoryNameen;
    _status = status;
    categories = lang;
}

  Main_Category.fromJson(dynamic json) {
    _id = json["id"];
    _allcategory_id = json["allcategory_id"];
    name = json["name"];
    name_en = json["name_en"];
    _status = json["level"];

    if(json["categories"]!=null){
      categories=List<Main_Category>();
      json["categories"].forEach((v) {
        categories.add(Main_Category.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["main_category_name"] = name;
    map["status"] = _status;
    map["lang"] = categories;
    return map;
  }

}