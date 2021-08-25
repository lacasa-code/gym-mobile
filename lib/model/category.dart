/// data : [{"id":1,"name":"first categoryEdit Category Name","description":"first category description12","photo":{"id":31,"image":"https://traker.fra1.digitaloceanspaces.com/product-categories/GMBrUb3WOI6srvS08ljBhyifxKsPr5VZMbbUaGF9.jpg","url":"https://development.lacasacode.dev/storage/31/GMBrUb3WOI6srvS08ljBhyifxKsPr5VZMbbUaGF9.jpg","fullurl":"https://development.lacasacode.dev/storage/31/GMBrUb3WOI6srvS08ljBhyifxKsPr5VZMbbUaGF9.jpg"}}]

class Category_model {
  List<Categories> _data;

  List<Categories> get data => _data;

  Category_model({List<Categories> data}) {
    _data = data;
  }

  Category_model.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Categories.fromJson(v));
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
/// name : "first categoryEdit Category Name"
/// description : "first category description12"
/// photo : {"id":31,"image":"https://traker.fra1.digitaloceanspaces.com/product-categories/GMBrUb3WOI6srvS08ljBhyifxKsPr5VZMbbUaGF9.jpg","url":"https://development.lacasacode.dev/storage/31/GMBrUb3WOI6srvS08ljBhyifxKsPr5VZMbbUaGF9.jpg","fullurl":"https://development.lacasacode.dev/storage/31/GMBrUb3WOI6srvS08ljBhyifxKsPr5VZMbbUaGF9.jpg"}

class Categories {
  int _id;
  String _name;
  String _name_en;
  String _description;
  Photo _photo;

  int get id => _id;
  String get name => _name;
  String get name_en => _name_en;
  String get description => _description;
  Photo get photo => _photo;

  Categories({int id, String name,String name_en, String description, Photo photo}) {
    _id = id;
    _name = name;
    _name_en = name_en;
    _description = description;
    _photo = photo;
  }

  Categories.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _name_en = json["name_en"];
    _description = json["description"];
    _photo = json["photo"] != null ? Photo.fromJson(json["photo"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["description"] = _description;
    if (_photo != null) {
      map["photo"] = _photo.toJson();
    }
    return map;
  }
}

/// id : 31
/// image : "https://traker.fra1.digitaloceanspaces.com/product-categories/GMBrUb3WOI6srvS08ljBhyifxKsPr5VZMbbUaGF9.jpg"
/// url : "https://development.lacasacode.dev/storage/31/GMBrUb3WOI6srvS08ljBhyifxKsPr5VZMbbUaGF9.jpg"
/// fullurl : "https://development.lacasacode.dev/storage/31/GMBrUb3WOI6srvS08ljBhyifxKsPr5VZMbbUaGF9.jpg"

class Photo {
  int _id;
  String _image;
  String _url;
  String _fullurl;

  int get id => _id;
  String get image => _image;
  String get url => _url;
  String get fullurl => _fullurl;

  Photo({int id, String image, String url, String fullurl}) {
    _id = id;
    _image = image;
    _url = url;
    _fullurl = fullurl;
  }

  Photo.fromJson(dynamic json) {
    _id = json["id"];
    _image = json["image"];
    _url = json["url"];
    _fullurl = json["fullurl"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["image"] = _image;
    map["url"] = _url;
    map["fullurl"] = _fullurl;
    return map;
  }
}
