/// data : [{"id":1,"title":"Admin","added_by_id":1},{"id":2,"title":"User","added_by_id":1},{"id":3,"title":"Vendor","added_by_id":1}]

class Roles_model {
  List<Role> _data;

  List<Role> get data => _data;

  Roles_model({
      List<Role> data}){
    _data = data;
}

  Roles_model.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Role.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// title : "Admin"
/// added_by_id : 1

class Role {
  int _id;
  String _title;
  int _addedById;

  int get id => _id;
  String get title => _title;
  int get addedById => _addedById;

  Role({
      int id, 
      String title, 
      int addedById}){
    _id = id;
    _title = title;
    _addedById = addedById;
}

  Role.fromJson(dynamic json) {
    _id = json["id"];
    _title = json["title"];
    _addedById = json["added_by_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["title"] = _title;
    map["added_by_id"] = _addedById;
    return map;
  }

}