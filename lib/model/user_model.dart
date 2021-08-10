import 'package:trkar_vendor/model/roles_model.dart';

class User_model {
  List<User> data;
  int total;

  User_model({this.data, this.total});

  User_model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<User>();
      json['data'].forEach((v) {
        data.add(new User.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class User {
  int id;
  String name;
  String email;
  String password;
  bool isSelect=false;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  int addedById;
  String serialId;
  String rolesid;
  String storeid;
  List<Stores> stores;
  int approved;
  Role roles;

  User(
      {this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.addedById,
        this.serialId,
        this.stores,
        this.approved,this.rolesid,
        this.storeid,
        this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    addedById = json['added_by_id'];
    serialId = json['serial_id'];
    if (json['stores'] != null) {
      stores = new List<Stores>();
      json['stores'].forEach((v) {
        stores.add(new Stores.fromJson(v));
      });
    }
    approved = json['approved'];
    roles = json['roles'] != null ? new Role.fromJson(json['roles']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['rolesid'] = this.rolesid;
    data['storeid'] = this.storeid;
  }
}

class Stores {
  int id;
  String name;
  String address;
  String lat;
  String long;
  int vendorId;
  String moderatorName;
  String moderatorPhone;
  String moderatorAltPhone;
  int status;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  String lang;
  int headCenter;
  Null countryId;
  Null areaId;
  Null cityId;
  Null serialId;
  Pivot pivot;

  Stores(
      {this.id,
        this.name,
        this.address,
        this.lat,
        this.long,
        this.vendorId,
        this.moderatorName,
        this.moderatorPhone,
        this.moderatorAltPhone,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.lang,
        this.headCenter,
        this.countryId,
        this.areaId,
        this.cityId,
        this.serialId,
        this.pivot});

  Stores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    lat = json['lat'];
    long = json['long'];
    vendorId = json['vendor_id'];
    moderatorName = json['moderator_name'];
    moderatorPhone = json['moderator_phone'];
    moderatorAltPhone = json['moderator_alt_phone'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    lang = json['lang'];
    headCenter = json['head_center'];
    countryId = json['country_id'];
    areaId = json['area_id'];
    cityId = json['city_id'];
    serialId = json['serial_id'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['vendor_id'] = this.vendorId;
    data['moderator_name'] = this.moderatorName;
    data['moderator_phone'] = this.moderatorPhone;
    data['moderator_alt_phone'] = this.moderatorAltPhone;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['lang'] = this.lang;
    data['head_center'] = this.headCenter;
    data['country_id'] = this.countryId;
    data['area_id'] = this.areaId;
    data['city_id'] = this.cityId;
    data['serial_id'] = this.serialId;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    return data;
  }
}

class Pivot {
  int vendorstaffId;
  int storeId;

  Pivot({this.vendorstaffId, this.storeId});

  Pivot.fromJson(Map<String, dynamic> json) {
    vendorstaffId = json['vendorstaff_id'];
    storeId = json['store_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendorstaff_id'] = this.vendorstaffId;
    data['store_id'] = this.storeId;
    return data;
  }
}


