/// id : 1
/// carmodel : "first model"
/// created_at : "2021-03-10 08:27:12"
/// updated_at : null
/// deleted_at : null
/// carmade_id : 2

class Carmodel {
  int _id;
  String _carmodel;
  String _name_en;
  String _createdAt;
  dynamic _updatedAt;
  dynamic _deletedAt;
  int _carmadeId;

  int get id => _id;
  String get carmodel => _carmodel;
  String get name_en => _name_en;
  String get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;
  int get carmadeId => _carmadeId;

  Carmodel({
      int id, 
      String carmodel, 
      String createdAt, 
      dynamic updatedAt, 
      dynamic deletedAt, 
      int carmadeId}){
    _id = id;
    _carmodel = carmodel;
    _name_en = name_en;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _carmadeId = carmadeId;
}

  Carmodel.fromJson(dynamic json) {
    _id = json["id"];
    _carmodel = json["carmodel"];
    _name_en = json["name_en"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    _deletedAt = json["deleted_at"];
    _carmadeId = json["carmade_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["carmodel"] = _carmodel;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    map["deleted_at"] = _deletedAt;
    map["carmade_id"] = _carmadeId;
    return map;
  }

}