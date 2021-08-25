/// status_code : 200
/// message : "success"
/// data : [{"id":1,"category_name":"first part category","created_at":null,"updated_at":null,"deleted_at":null,"photo":null,"media":[]}]

class Parts_Category {
  int _statusCode;
  String _message;
  List<Part_Category> _data;

  int get statusCode => _statusCode;
  String get message => _message;
  List<Part_Category> get data => _data;

  Parts_Category({
      int statusCode, 
      String message, 
      List<Part_Category> data}){
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  Parts_Category.fromJson(dynamic json) {
    _statusCode = json["status_code"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Part_Category.fromJson(v));
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
/// category_name : "first part category"
/// created_at : null
/// updated_at : null
/// deleted_at : null
/// photo : null
/// media : []

class Part_Category {
  int _id;
  String _categoryName;
  String _categoryName_en;
  dynamic _createdAt;
  dynamic _updatedAt;
  dynamic _deletedAt;
  dynamic _photo;
  List<dynamic> _media;

  int get id => _id;
  String get categoryName => _categoryName;
  String get categoryname_en => _categoryName_en;
  dynamic get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;
  dynamic get photo => _photo;
  List<dynamic> get media => _media;

  Part_Category({
      int id, 
      String categoryName, 
      dynamic createdAt, 
      dynamic updatedAt, 
      dynamic deletedAt, 
      dynamic photo, 
      List<dynamic> media}){
    _id = id;
    _categoryName = categoryName;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _photo = photo;
    _media = media;
}

  Part_Category.fromJson(dynamic json) {
    _id = json["id"];
    _categoryName = json["category_name"];
    _categoryName_en = json["name_en"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    _deletedAt = json["deleted_at"];
    _photo = json["photo"];

  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["category_name"] = _categoryName;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    map["deleted_at"] = _deletedAt;
    map["photo"] = _photo;
    if (_media != null) {
      map["media"] = _media.map((v) => v.toJson()).toList();
    }
    return map;
  }

}