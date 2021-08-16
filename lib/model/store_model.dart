class Store_model {
  int statusCode;
  String message;
  List<Store> data;
  int total;

  Store_model({this.statusCode, this.message, this.data, this.total});

  Store_model.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Store>();
      json['data'].forEach((v) {
        data.add(new Store.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Store {
  int id;
  String name;
  String address;
  bool isSelect=false;
  String lat;
  String long;
  int vendorId;
  int countryId;
  int areaId;
  int cityId;
  String countryName;
  String areaName;
  String cityName;
  int headCenter;
  String serialId;
  String moderatorPhone;
  String moderatorAltPhone;
  int status;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  String vendorName;
  Vendor vendor;
  List<Members> members;

  Store(
      {this.id,
        this.name,
        this.address,
        this.lat,
        this.long,
        this.vendorId,
        this.countryId,
        this.areaId,
        this.cityId,
        this.countryName,
        this.areaName,
        this.cityName,
        this.headCenter,
        this.serialId,
        this.moderatorPhone,
        this.moderatorAltPhone,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.vendorName,
        this.vendor,
        this.members});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    lat = json['lat'];
    long = json['long'];
    vendorId = json['vendor_id'];
    countryId = json['country_id'];
    areaId = json['area_id'];
    cityId = json['city_id'];
    countryName = json['country_name'];
    areaName = json['area_name'];
    cityName = json['city_name'];
    headCenter = json['head_center'];
    serialId = json['serial_id'];
    moderatorPhone = json['moderator_phone'];
    moderatorAltPhone = json['moderator_alt_phone'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    vendorName = json['vendor_name'];
    vendor =
    json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
    if (json['members'] != null) {
      members = new List<Members>();
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
      var map = <String, dynamic>{};
      map["name"] = name;
      map["address"] = address;
      map["lat"] = lat;
      map["long"] = long;
      map["country_id"] = countryId;
      map["area_id"] = areaId;
      map["city_id"] = cityId;
      map["moderator_phone"] = moderatorPhone;
      if (moderatorAltPhone.isNotEmpty) {
        map["moderator_alt_phone"] = moderatorAltPhone;}
    return map;
  }
}

class Vendor {
  int id;
  String vendorName;
  String email;
  String type;
  String serial;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  int useridId;
  String lang;
  String commercialNo;
  String commercialDoc;
  String taxCardNo;
  String taxCardDoc;
  String bankAccount;
  int approved;
  int complete;
  int declined;
  int rejected;
  String companyName;
  Images images;
  CommercialDocs commercialDocs;
  CommercialDocs taxCardDocs;
  CommercialDocs wholesaleDocs;
  CommercialDocs bankDocs;

  Vendor(
      {this.id,
        this.vendorName,
        this.email,
        this.type,
        this.serial,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.useridId,
        this.lang,
        this.commercialNo,
        this.commercialDoc,
        this.taxCardNo,
        this.taxCardDoc,
        this.bankAccount,
        this.approved,
        this.complete,
        this.declined,
        this.rejected,
        this.companyName,
        this.images,
        this.commercialDocs,
        this.taxCardDocs,
        this.wholesaleDocs,
        this.bankDocs});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorName = json['vendor_name'];
    email = json['email'];
    type = json['type'];
    serial = json['serial'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    useridId = json['userid_id'];
    lang = json['lang'];
    commercialNo = json['commercial_no'];
    commercialDoc = json['commercial_doc'];
    taxCardNo = json['tax_card_no'];
    taxCardDoc = json['tax_card_doc'];
    bankAccount = json['bank_account'];
    approved = json['approved'];
    complete = json['complete'];
    declined = json['declined'];
    rejected = json['rejected'];
    companyName = json['company_name'];
    images =
    json['images'] != null ? new Images.fromJson(json['images']) : null;
    commercialDocs = json['commercialDocs'] != null
        ? new CommercialDocs.fromJson(json['commercialDocs'])
        : null;
    taxCardDocs = json['taxCardDocs'] != null
        ? new CommercialDocs.fromJson(json['taxCardDocs'])
        : null;
    wholesaleDocs = json['wholesaleDocs'] != null
        ? new CommercialDocs.fromJson(json['wholesaleDocs'])
        : null;
    bankDocs = json['bankDocs'] != null
        ? new CommercialDocs.fromJson(json['bankDocs'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_name'] = this.vendorName;
    data['email'] = this.email;
    data['type'] = this.type;
    data['serial'] = this.serial;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['userid_id'] = this.useridId;
    data['lang'] = this.lang;
    data['commercial_no'] = this.commercialNo;
    data['commercial_doc'] = this.commercialDoc;
    data['tax_card_no'] = this.taxCardNo;
    data['tax_card_doc'] = this.taxCardDoc;
    data['bank_account'] = this.bankAccount;
    data['approved'] = this.approved;
    data['complete'] = this.complete;
    data['declined'] = this.declined;
    data['rejected'] = this.rejected;
    data['company_name'] = this.companyName;
    if (this.images != null) {
      data['images'] = this.images.toJson();
    }
    if (this.commercialDocs != null) {
      data['commercialDocs'] = this.commercialDocs.toJson();
    }
    if (this.taxCardDocs != null) {
      data['taxCardDocs'] = this.taxCardDocs.toJson();
    }
    if (this.wholesaleDocs != null) {
      data['wholesaleDocs'] = this.wholesaleDocs.toJson();
    }
    if (this.bankDocs != null) {
      data['bankDocs'] = this.bankDocs.toJson();
    }

    return data;
  }
}

class Images {
  int id;
  String modelType;
  int modelId;
  String uuid;
  String collectionName;
  String name;
  String fileName;
  String mimeType;
  String disk;
  String conversionsDisk;
  int size;
  CustomProperties customProperties;
  int orderColumn;
  String createdAt;
  String updatedAt;
  String image;
  String url;
  String fullurl;
  String thumbnail;
  String preview;

  Images(
      {this.id,
        this.modelType,
        this.modelId,
        this.uuid,
        this.collectionName,
        this.name,
        this.fileName,
        this.mimeType,
        this.disk,
        this.conversionsDisk,
        this.size,
        this.customProperties,
        this.orderColumn,
        this.createdAt,
        this.updatedAt,
        this.image,
        this.url,
        this.fullurl,
        this.thumbnail,
        this.preview});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modelType = json['model_type'];
    modelId = json['model_id'];
    uuid = json['uuid'];
    collectionName = json['collection_name'];
    name = json['name'];
    fileName = json['file_name'];
    mimeType = json['mime_type'];
    disk = json['disk'];
    conversionsDisk = json['conversions_disk'];
    size = json['size'];

    customProperties = json['custom_properties'] != null
        ? new CustomProperties.fromJson(json['custom_properties'])
        : null;
    orderColumn = json['order_column'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    url = json['url'];
    fullurl = json['fullurl'];
    thumbnail = json['thumbnail'];
    preview = json['preview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['model_type'] = this.modelType;
    data['model_id'] = this.modelId;
    data['uuid'] = this.uuid;
    data['collection_name'] = this.collectionName;
    data['name'] = this.name;
    data['file_name'] = this.fileName;
    data['mime_type'] = this.mimeType;
    data['disk'] = this.disk;
    data['conversions_disk'] = this.conversionsDisk;
    data['size'] = this.size;
    if (this.customProperties != null) {
      data['custom_properties'] = this.customProperties.toJson();
    }
    data['order_column'] = this.orderColumn;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    data['url'] = this.url;
    data['fullurl'] = this.fullurl;
    data['thumbnail'] = this.thumbnail;
    data['preview'] = this.preview;
    return data;
  }
}

class CustomProperties {
  GeneratedConversions generatedConversions;

  CustomProperties({this.generatedConversions});

  CustomProperties.fromJson(Map<String, dynamic> json) {
    generatedConversions = json['generated_conversions'] != null
        ? new GeneratedConversions.fromJson(json['generated_conversions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.generatedConversions != null) {
      data['generated_conversions'] = this.generatedConversions.toJson();
    }
    return data;
  }
}

class GeneratedConversions {
  bool thumb;
  bool preview;

  GeneratedConversions({this.thumb, this.preview});

  GeneratedConversions.fromJson(Map<String, dynamic> json) {
    thumb = json['thumb'];
    preview = json['preview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['thumb'] = this.thumb;
    data['preview'] = this.preview;
    return data;
  }
}

class CommercialDocs {
  int id;
  String modelType;
  int modelId;
  String uuid;
  String collectionName;
  String name;
  String fileName;
  String mimeType;
  String disk;
  String conversionsDisk;
  int size;
  List<Null> manipulations;
  List<Null> customProperties;
  List<Null> responsiveImages;
  int orderColumn;
  String createdAt;
  String updatedAt;
  String image;
  String url;
  String fullurl;
  String thumbnail;
  String preview;

  CommercialDocs(
      {this.id,
        this.modelType,
        this.modelId,
        this.uuid,
        this.collectionName,
        this.name,
        this.fileName,
        this.mimeType,
        this.disk,
        this.conversionsDisk,
        this.size,
        this.manipulations,
        this.customProperties,
        this.responsiveImages,
        this.orderColumn,
        this.createdAt,
        this.updatedAt,
        this.image,
        this.url,
        this.fullurl,
        this.thumbnail,
        this.preview});

  CommercialDocs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modelType = json['model_type'];
    modelId = json['model_id'];
    uuid = json['uuid'];
    collectionName = json['collection_name'];
    name = json['name'];
    fileName = json['file_name'];
    mimeType = json['mime_type'];
    disk = json['disk'];
    conversionsDisk = json['conversions_disk'];
    size = json['size'];



    orderColumn = json['order_column'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    url = json['url'];
    fullurl = json['fullurl'];
    thumbnail = json['thumbnail'];
    preview = json['preview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['model_type'] = this.modelType;
    data['model_id'] = this.modelId;
    data['uuid'] = this.uuid;
    data['collection_name'] = this.collectionName;
    data['name'] = this.name;
    data['file_name'] = this.fileName;
    data['mime_type'] = this.mimeType;
    data['disk'] = this.disk;
    data['conversions_disk'] = this.conversionsDisk;
    data['size'] = this.size;

    data['order_column'] = this.orderColumn;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    data['url'] = this.url;
    data['fullurl'] = this.fullurl;
    data['thumbnail'] = this.thumbnail;
    data['preview'] = this.preview;
    return data;
  }
}

class Members {
  String name;
  String email;
  String roleName;

  Members({this.name, this.email, this.roleName});

  Members.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['role_name'] = this.roleName;
    return data;
  }
}
