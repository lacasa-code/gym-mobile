/// data : [{"id":1,"producttype":"normal","lang":"ar","status":1},{"id":2,"producttype":"wholesale","lang":"ar","status":1},{"id":3,"producttype":"both","lang":"ar","status":1}]

class ProductTypeModel {
  List<ProductType> _data;

  List<ProductType> get data => _data;

  ProductTypeModel({
      List<ProductType> data}){
    _data = data;
}

  ProductTypeModel.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(ProductType.fromJson(v));
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
/// producttype : "normal"
/// lang : "ar"
/// status : 1

class ProductType {
  int _id;
  String _producttype;
  String _lang;
  int _status;

  int get id => _id;
  String get producttype => _producttype;
  String get lang => _lang;
  int get status => _status;

  ProductType({
      int id, 
      String producttype, 
      String lang, 
      int status}){
    _id = id;
    _producttype = producttype;
    _lang = lang;
    _status = status;
}

  ProductType.fromJson(dynamic json) {
    _id = json["id"];
    _producttype = json["producttype"];
    _lang = json["lang"];
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["producttype"] = _producttype;
    map["lang"] = _lang;
    map["status"] = _status;
    return map;
  }

}