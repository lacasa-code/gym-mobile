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

  int get id => _id;
  String get name => _name;

  Tag({int id, String name}) {
    _id = id;
    _name = name;
  }

  Tag.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    return map;
  }
}
