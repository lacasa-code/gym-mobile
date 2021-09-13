import 'package:trkar_vendor/model/roles_model.dart';
import 'package:trkar_vendor/model/store_model.dart';

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
  List<Store> stores;
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
      stores = new List<Store>();
      json['stores'].forEach((v) {
        stores.add(new Store.fromJson(v));
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


