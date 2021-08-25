/// data : [{"id":1,"name":"tag one"}]

class Tags_model {
  List<Tag> _data;

  List<Tag> get data => _data;

  Tags_model({List<Tag> data}) {
    _data = data;
  }

  Tags_model.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Tag.fromJson(v));
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
/// name : "tag one"

class Tag {
  int _id;
  String _name;
  String _name_en;

  int get id => _id;
  String get name => _name;
  String get name_en => _name_en;

  Tag({int id, String name}) {
    _id = id;
    _name = name;
    _name_en = name_en;
  }

  Tag.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _name_en = json["name_en"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    return map;
  }
}
