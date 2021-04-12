/// data : [{"id":4,"name":"A Store","address":"Address","lat":"29.990883663215","long":"30.909787416458","vendor_id":2,"moderator_name":"Moderator","moderator_phone":"966501111111","moderator_alt_phone":"966501111111","status":1,"created_at":"2021-03-07T08:44:36.000000Z","updated_at":"2021-03-07T08:44:36.000000Z","deleted_at":null,"vendor_name":"second  vendor","vendor":{"id":2,"vendor_name":"second  vendor","email":"second@second.com","type":"1","serial":"V002","created_at":"2021-03-09 14:24:50","updated_at":"2021-03-14 11:41:50","deleted_at":null,"userid_id":2,"images":{"id":25,"model_type":"App\\Models\\AddVendor","model_id":2,"uuid":"56174073-a706-423f-a505-6123e436cb78","collection_name":"images","name":"6047852d71270_img","file_name":"6047852d71270_img.png","mime_type":"image/png","disk":"public","conversions_disk":"public","size":7308,"manipulations":[],"custom_properties":{"generated_conversions":{"thumb":true,"preview":true}},"responsive_images":[],"order_column":25,"created_at":"2021-03-09T14:24:50.000000Z","updated_at":"2021-03-09T14:24:51.000000Z","image":"https://traker.fra1.digitaloceanspaces.com/add-vendors/6047852d71270_img.png","url":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","fullurl":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","thumbnail":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-thumb.jpg","preview":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-preview.jpg"},"media":[{"id":25,"model_type":"App\\Models\\AddVendor","model_id":2,"uuid":"56174073-a706-423f-a505-6123e436cb78","collection_name":"images","name":"6047852d71270_img","file_name":"6047852d71270_img.png","mime_type":"image/png","disk":"public","conversions_disk":"public","size":7308,"manipulations":[],"custom_properties":{"generated_conversions":{"thumb":true,"preview":true}},"responsive_images":[],"order_column":25,"created_at":"2021-03-09T14:24:50.000000Z","updated_at":"2021-03-09T14:24:51.000000Z","image":"https://traker.fra1.digitaloceanspaces.com/add-vendors/6047852d71270_img.png","url":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","fullurl":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","thumbnail":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-thumb.jpg","preview":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-preview.jpg"}]}},{"id":2,"name":"updated store","address":"address2","lat":"40.111","long":"40.111","vendor_id":2,"moderator_name":"mod2","moderator_phone":"966555888777","moderator_alt_phone":null,"status":1,"created_at":"2021-03-01T19:57:23.000000Z","updated_at":"2021-04-05T11:39:45.000000Z","deleted_at":null,"vendor_name":"second  vendor","vendor":{"id":2,"vendor_name":"second  vendor","email":"second@second.com","type":"1","serial":"V002","created_at":"2021-03-09 14:24:50","updated_at":"2021-03-14 11:41:50","deleted_at":null,"userid_id":2,"images":{"id":25,"model_type":"App\\Models\\AddVendor","model_id":2,"uuid":"56174073-a706-423f-a505-6123e436cb78","collection_name":"images","name":"6047852d71270_img","file_name":"6047852d71270_img.png","mime_type":"image/png","disk":"public","conversions_disk":"public","size":7308,"manipulations":[],"custom_properties":{"generated_conversions":{"thumb":true,"preview":true}},"responsive_images":[],"order_column":25,"created_at":"2021-03-09T14:24:50.000000Z","updated_at":"2021-03-09T14:24:51.000000Z","image":"https://traker.fra1.digitaloceanspaces.com/add-vendors/6047852d71270_img.png","url":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","fullurl":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","thumbnail":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-thumb.jpg","preview":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-preview.jpg"},"media":[{"id":25,"model_type":"App\\Models\\AddVendor","model_id":2,"uuid":"56174073-a706-423f-a505-6123e436cb78","collection_name":"images","name":"6047852d71270_img","file_name":"6047852d71270_img.png","mime_type":"image/png","disk":"public","conversions_disk":"public","size":7308,"manipulations":[],"custom_properties":{"generated_conversions":{"thumb":true,"preview":true}},"responsive_images":[],"order_column":25,"created_at":"2021-03-09T14:24:50.000000Z","updated_at":"2021-03-09T14:24:51.000000Z","image":"https://traker.fra1.digitaloceanspaces.com/add-vendors/6047852d71270_img.png","url":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","fullurl":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","thumbnail":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-thumb.jpg","preview":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-preview.jpg"}]}}]
/// total : 2

class Store_model {
  List<Store> _data;
  int _total;

  List<Store> get data => _data;
  int get total => _total;

  Store_model({List<Store> data, int total}) {
    _data = data;
    _total = total;
  }

  Store_model.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Store.fromJson(v));
      });
    }
    _total = json["total"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    map["total"] = _total;
    return map;
  }
}

/// id : 4
/// name : "A Store"
/// address : "Address"
/// lat : "29.990883663215"
/// long : "30.909787416458"
/// vendor_id : 2
/// moderator_name : "Moderator"
/// moderator_phone : "966501111111"
/// moderator_alt_phone : "966501111111"
/// status : 1
/// created_at : "2021-03-07T08:44:36.000000Z"
/// updated_at : "2021-03-07T08:44:36.000000Z"
/// deleted_at : null
/// vendor_name : "second  vendor"
/// vendor : {"id":2,"vendor_name":"second  vendor","email":"second@second.com","type":"1","serial":"V002","created_at":"2021-03-09 14:24:50","updated_at":"2021-03-14 11:41:50","deleted_at":null,"userid_id":2,"images":{"id":25,"model_type":"App\\Models\\AddVendor","model_id":2,"uuid":"56174073-a706-423f-a505-6123e436cb78","collection_name":"images","name":"6047852d71270_img","file_name":"6047852d71270_img.png","mime_type":"image/png","disk":"public","conversions_disk":"public","size":7308,"manipulations":[],"custom_properties":{"generated_conversions":{"thumb":true,"preview":true}},"responsive_images":[],"order_column":25,"created_at":"2021-03-09T14:24:50.000000Z","updated_at":"2021-03-09T14:24:51.000000Z","image":"https://traker.fra1.digitaloceanspaces.com/add-vendors/6047852d71270_img.png","url":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","fullurl":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","thumbnail":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-thumb.jpg","preview":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-preview.jpg"},"media":[{"id":25,"model_type":"App\\Models\\AddVendor","model_id":2,"uuid":"56174073-a706-423f-a505-6123e436cb78","collection_name":"images","name":"6047852d71270_img","file_name":"6047852d71270_img.png","mime_type":"image/png","disk":"public","conversions_disk":"public","size":7308,"manipulations":[],"custom_properties":{"generated_conversions":{"thumb":true,"preview":true}},"responsive_images":[],"order_column":25,"created_at":"2021-03-09T14:24:50.000000Z","updated_at":"2021-03-09T14:24:51.000000Z","image":"https://traker.fra1.digitaloceanspaces.com/add-vendors/6047852d71270_img.png","url":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","fullurl":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","thumbnail":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-thumb.jpg","preview":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-preview.jpg"}]}

class Store {
  int _id;
  String _name;
  String _address;
  String _lat;
  String _long;
  int _vendorId;
  String _moderatorName;
  String _moderatorPhone;
  String _moderatorAltPhone;
  int _status;
  String _createdAt;
  String _updatedAt;
  dynamic _deletedAt;
  String _vendorName;
  Vendor _vendor;

  int get id => _id;
  String get name => _name;
  String get address => _address;
  String get lat => _lat;
  String get long => _long;
  int get vendorId => _vendorId;
  String get moderatorName => _moderatorName;
  String get moderatorPhone => _moderatorPhone;
  String get moderatorAltPhone => _moderatorAltPhone;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;
  String get vendorName => _vendorName;
  Vendor get vendor => _vendor;

  Store(
      {int id,
      String name,
      String address,
      String lat,
      String long,
      int vendorId,
      String moderatorName,
      String moderatorPhone,
      String moderatorAltPhone,
      int status,
      String createdAt,
      String updatedAt,
      dynamic deletedAt,
      String vendorName,
      Vendor vendor}) {
    _id = id;
    _name = name;
    _address = address;
    _lat = lat;
    _long = long;
    _vendorId = vendorId;
    _moderatorName = moderatorName;
    _moderatorPhone = moderatorPhone;
    _moderatorAltPhone = moderatorAltPhone;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _vendorName = vendorName;
    _vendor = vendor;
  }

  Store.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _address = json["address"];
    _lat = json["lat"];
    _long = json["long"];
    _vendorId = json["vendor_id"];
    _moderatorName = json["moderator_name"];
    _moderatorPhone = json["moderator_phone"];
    _moderatorAltPhone = json["moderator_alt_phone"];
    _status = json["status"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    _deletedAt = json["deleted_at"];
    _vendorName = json["vendor_name"];
    _vendor = json["vendor"] != null ? Vendor.fromJson(json["vendor"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["address"] = _address;
    map["lat"] = _lat;
    map["long"] = _long;
    map["vendor_id"] = _vendorId;
    map["moderator_name"] = _moderatorName;
    map["moderator_phone"] = _moderatorPhone;
    map["moderator_alt_phone"] = _moderatorAltPhone;
    map["status"] = _status;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    map["deleted_at"] = _deletedAt;
    map["vendor_name"] = _vendorName;
    if (_vendor != null) {
      map["vendor"] = _vendor.toJson();
    }
    return map;
  }
}

/// id : 2
/// vendor_name : "second  vendor"
/// email : "second@second.com"
/// type : "1"
/// serial : "V002"
/// created_at : "2021-03-09 14:24:50"
/// updated_at : "2021-03-14 11:41:50"
/// deleted_at : null
/// userid_id : 2
/// images : {"id":25,"model_type":"App\\Models\\AddVendor","model_id":2,"uuid":"56174073-a706-423f-a505-6123e436cb78","collection_name":"images","name":"6047852d71270_img","file_name":"6047852d71270_img.png","mime_type":"image/png","disk":"public","conversions_disk":"public","size":7308,"manipulations":[],"custom_properties":{"generated_conversions":{"thumb":true,"preview":true}},"responsive_images":[],"order_column":25,"created_at":"2021-03-09T14:24:50.000000Z","updated_at":"2021-03-09T14:24:51.000000Z","image":"https://traker.fra1.digitaloceanspaces.com/add-vendors/6047852d71270_img.png","url":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","fullurl":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","thumbnail":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-thumb.jpg","preview":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-preview.jpg"}
/// media : [{"id":25,"model_type":"App\\Models\\AddVendor","model_id":2,"uuid":"56174073-a706-423f-a505-6123e436cb78","collection_name":"images","name":"6047852d71270_img","file_name":"6047852d71270_img.png","mime_type":"image/png","disk":"public","conversions_disk":"public","size":7308,"manipulations":[],"custom_properties":{"generated_conversions":{"thumb":true,"preview":true}},"responsive_images":[],"order_column":25,"created_at":"2021-03-09T14:24:50.000000Z","updated_at":"2021-03-09T14:24:51.000000Z","image":"https://traker.fra1.digitaloceanspaces.com/add-vendors/6047852d71270_img.png","url":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","fullurl":"https://development.lacasacode.dev/storage/25/6047852d71270_img.png","thumbnail":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-thumb.jpg","preview":"https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-preview.jpg"}]

class Vendor {
  int _id;
  String _vendorName;
  String _email;
  String _type;
  String _serial;
  String _createdAt;
  String _updatedAt;
  dynamic _deletedAt;
  int _useridId;
  Images _images;
  List<Media> _media;

  int get id => _id;
  String get vendorName => _vendorName;
  String get email => _email;
  String get type => _type;
  String get serial => _serial;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;
  int get useridId => _useridId;
  Images get images => _images;
  List<Media> get media => _media;

  Vendor(
      {int id,
      String vendorName,
      String email,
      String type,
      String serial,
      String createdAt,
      String updatedAt,
      dynamic deletedAt,
      int useridId,
      Images images,
      List<Media> media}) {
    _id = id;
    _vendorName = vendorName;
    _email = email;
    _type = type;
    _serial = serial;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _useridId = useridId;
    _images = images;
    _media = media;
  }

  Vendor.fromJson(dynamic json) {
    _id = json["id"];
    _vendorName = json["vendor_name"];
    _email = json["email"];
    _type = json["type"];
    _serial = json["serial"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    _deletedAt = json["deleted_at"];
    _useridId = json["userid_id"];
    _images = json["images"] != null ? Images.fromJson(json["images"]) : null;
    if (json["media"] != null) {
      _media = [];
      json["media"].forEach((v) {
        _media.add(Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["vendor_name"] = _vendorName;
    map["email"] = _email;
    map["type"] = _type;
    map["serial"] = _serial;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    map["deleted_at"] = _deletedAt;
    map["userid_id"] = _useridId;
    if (_images != null) {
      map["images"] = _images.toJson();
    }
    if (_media != null) {
      map["media"] = _media.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 25
/// model_type : "App\\Models\\AddVendor"
/// model_id : 2
/// uuid : "56174073-a706-423f-a505-6123e436cb78"
/// collection_name : "images"
/// name : "6047852d71270_img"
/// file_name : "6047852d71270_img.png"
/// mime_type : "image/png"
/// disk : "public"
/// conversions_disk : "public"
/// size : 7308
/// manipulations : []
/// custom_properties : {"generated_conversions":{"thumb":true,"preview":true}}
/// responsive_images : []
/// order_column : 25
/// created_at : "2021-03-09T14:24:50.000000Z"
/// updated_at : "2021-03-09T14:24:51.000000Z"
/// image : "https://traker.fra1.digitaloceanspaces.com/add-vendors/6047852d71270_img.png"
/// url : "https://development.lacasacode.dev/storage/25/6047852d71270_img.png"
/// fullurl : "https://development.lacasacode.dev/storage/25/6047852d71270_img.png"
/// thumbnail : "https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-thumb.jpg"
/// preview : "https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-preview.jpg"

class Media {
  int _id;
  String _modelType;
  int _modelId;
  String _uuid;
  String _collectionName;
  String _name;
  String _fileName;
  String _mimeType;
  String _disk;
  String _conversionsDisk;
  int _size;
  List<dynamic> _manipulations;
  List<dynamic> _responsiveImages;
  int _orderColumn;
  String _createdAt;
  String _updatedAt;
  String _image;
  String _url;
  String _fullurl;
  String _thumbnail;
  String _preview;

  int get id => _id;
  String get modelType => _modelType;
  int get modelId => _modelId;
  String get uuid => _uuid;
  String get collectionName => _collectionName;
  String get name => _name;
  String get fileName => _fileName;
  String get mimeType => _mimeType;
  String get disk => _disk;
  String get conversionsDisk => _conversionsDisk;
  int get size => _size;
  List<dynamic> get manipulations => _manipulations;
  List<dynamic> get responsiveImages => _responsiveImages;
  int get orderColumn => _orderColumn;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get image => _image;
  String get url => _url;
  String get fullurl => _fullurl;
  String get thumbnail => _thumbnail;
  String get preview => _preview;

  Media(
      {int id,
      String modelType,
      int modelId,
      String uuid,
      String collectionName,
      String name,
      String fileName,
      String mimeType,
      String disk,
      String conversionsDisk,
      int size,
      List<dynamic> manipulations,
      List<dynamic> responsiveImages,
      int orderColumn,
      String createdAt,
      String updatedAt,
      String image,
      String url,
      String fullurl,
      String thumbnail,
      String preview}) {
    _id = id;
    _modelType = modelType;
    _modelId = modelId;
    _uuid = uuid;
    _collectionName = collectionName;
    _name = name;
    _fileName = fileName;
    _mimeType = mimeType;
    _disk = disk;
    _conversionsDisk = conversionsDisk;
    _size = size;
    _manipulations = manipulations;
    _responsiveImages = responsiveImages;
    _orderColumn = orderColumn;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _image = image;
    _url = url;
    _fullurl = fullurl;
    _thumbnail = thumbnail;
    _preview = preview;
  }

  Media.fromJson(dynamic json) {
    _id = json["id"];
    _modelType = json["model_type"];
    _modelId = json["model_id"];
    _uuid = json["uuid"];
    _collectionName = json["collection_name"];
    _name = json["name"];
    _fileName = json["file_name"];
    _mimeType = json["mime_type"];
    _disk = json["disk"];
    _conversionsDisk = json["conversions_disk"];
    _size = json["size"];

    _orderColumn = json["order_column"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    _image = json["image"];
    _url = json["url"];
    _fullurl = json["fullurl"];
    _thumbnail = json["thumbnail"];
    _preview = json["preview"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["model_type"] = _modelType;
    map["model_id"] = _modelId;
    map["uuid"] = _uuid;
    map["collection_name"] = _collectionName;
    map["name"] = _name;
    map["file_name"] = _fileName;
    map["mime_type"] = _mimeType;
    map["disk"] = _disk;
    map["conversions_disk"] = _conversionsDisk;
    map["size"] = _size;
    if (_manipulations != null) {
      map["manipulations"] = _manipulations.map((v) => v.toJson()).toList();
    }

    if (_responsiveImages != null) {
      map["responsive_images"] =
          _responsiveImages.map((v) => v.toJson()).toList();
    }
    map["order_column"] = _orderColumn;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    map["image"] = _image;
    map["url"] = _url;
    map["fullurl"] = _fullurl;
    map["thumbnail"] = _thumbnail;
    map["preview"] = _preview;
    return map;
  }
}

/// generated_conversions : {"thumb":true,"preview":true}

/// id : 25
/// model_type : "App\\Models\\AddVendor"
/// model_id : 2
/// uuid : "56174073-a706-423f-a505-6123e436cb78"
/// collection_name : "images"
/// name : "6047852d71270_img"
/// file_name : "6047852d71270_img.png"
/// mime_type : "image/png"
/// disk : "public"
/// conversions_disk : "public"
/// size : 7308
/// manipulations : []
/// custom_properties : {"generated_conversions":{"thumb":true,"preview":true}}
/// responsive_images : []
/// order_column : 25
/// created_at : "2021-03-09T14:24:50.000000Z"
/// updated_at : "2021-03-09T14:24:51.000000Z"
/// image : "https://traker.fra1.digitaloceanspaces.com/add-vendors/6047852d71270_img.png"
/// url : "https://development.lacasacode.dev/storage/25/6047852d71270_img.png"
/// fullurl : "https://development.lacasacode.dev/storage/25/6047852d71270_img.png"
/// thumbnail : "https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-thumb.jpg"
/// preview : "https://development.lacasacode.dev/storage/25/conversions/6047852d71270_img-preview.jpg"

class Images {
  int _id;
  String _modelType;
  int _modelId;
  String _uuid;
  String _collectionName;
  String _name;
  String _fileName;
  String _mimeType;
  String _disk;
  String _conversionsDisk;
  int _size;
  List<dynamic> _manipulations;
  List<dynamic> _responsiveImages;
  int _orderColumn;
  String _createdAt;
  String _updatedAt;
  String _image;
  String _url;
  String _fullurl;
  String _thumbnail;
  String _preview;

  int get id => _id;
  String get modelType => _modelType;
  int get modelId => _modelId;
  String get uuid => _uuid;
  String get collectionName => _collectionName;
  String get name => _name;
  String get fileName => _fileName;
  String get mimeType => _mimeType;
  String get disk => _disk;
  String get conversionsDisk => _conversionsDisk;
  int get size => _size;
  List<dynamic> get manipulations => _manipulations;
  List<dynamic> get responsiveImages => _responsiveImages;
  int get orderColumn => _orderColumn;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get image => _image;
  String get url => _url;
  String get fullurl => _fullurl;
  String get thumbnail => _thumbnail;
  String get preview => _preview;

  Images(
      {int id,
      String modelType,
      int modelId,
      String uuid,
      String collectionName,
      String name,
      String fileName,
      String mimeType,
      String disk,
      String conversionsDisk,
      int size,
      List<dynamic> manipulations,
      List<dynamic> responsiveImages,
      int orderColumn,
      String createdAt,
      String updatedAt,
      String image,
      String url,
      String fullurl,
      String thumbnail,
      String preview}) {
    _id = id;
    _modelType = modelType;
    _modelId = modelId;
    _uuid = uuid;
    _collectionName = collectionName;
    _name = name;
    _fileName = fileName;
    _mimeType = mimeType;
    _disk = disk;
    _conversionsDisk = conversionsDisk;
    _size = size;
    _manipulations = manipulations;
    _responsiveImages = responsiveImages;
    _orderColumn = orderColumn;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _image = image;
    _url = url;
    _fullurl = fullurl;
    _thumbnail = thumbnail;
    _preview = preview;
  }

  Images.fromJson(dynamic json) {
    _id = json["id"];
    _modelType = json["model_type"];
    _modelId = json["model_id"];
    _uuid = json["uuid"];
    _collectionName = json["collection_name"];
    _name = json["name"];
    _fileName = json["file_name"];
    _mimeType = json["mime_type"];
    _disk = json["disk"];
    _conversionsDisk = json["conversions_disk"];
    _size = json["size"];

    _orderColumn = json["order_column"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    _image = json["image"];
    _url = json["url"];
    _fullurl = json["fullurl"];
    _thumbnail = json["thumbnail"];
    _preview = json["preview"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["model_type"] = _modelType;
    map["model_id"] = _modelId;
    map["uuid"] = _uuid;
    map["collection_name"] = _collectionName;
    map["name"] = _name;
    map["file_name"] = _fileName;
    map["mime_type"] = _mimeType;
    map["disk"] = _disk;
    map["conversions_disk"] = _conversionsDisk;
    map["size"] = _size;
    if (_manipulations != null) {
      map["manipulations"] = _manipulations.map((v) => v.toJson()).toList();
    }

    if (_responsiveImages != null) {
      map["responsive_images"] =
          _responsiveImages.map((v) => v.toJson()).toList();
    }
    map["order_column"] = _orderColumn;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    map["image"] = _image;
    map["url"] = _url;
    map["fullurl"] = _fullurl;
    map["thumbnail"] = _thumbnail;
    map["preview"] = _preview;
    return map;
  }
}
