import 'package:trkar_vendor/model/roles_model.dart';

/// data : [{"id":4,"name":"thirduser","email":"seconduser@user.com","added_by_id":2,"roles":[{"id":2,"title":"User","added_by_id":1,"pivot":{"user_id":4,"role_id":2}}]}]
/// total : 6

class User_model {
  List<User> _data;
  int _total;

  List<User> get data => _data;
  int get total => _total;

  User_model({List<User> data, int total}) {
    _data = data;
    _total = total;
  }

  User_model.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(User.fromJson(v));
      });
    }
    _total = json["total"];
  }
}

/// id : 4
/// name : "thirduser"
/// email : "seconduser@user.com"
/// added_by_id : 2
/// roles : [{"id":2,"title":"User","added_by_id":1,"pivot":{"user_id":4,"role_id":2}}]

class User {
  int id;
  String name;
  String email;
  String password;
  String passwordConfirmation;
  int _addedById;
  int rolesid;
  int storeid;
  Role _roles;
bool isSelect=false;

  int get addedById => _addedById;
  Role get roles => _roles;

  User({int id, String name, String email, int addedById, Role roles}) {
    id = id;
    name = name;
    email = email;
    _addedById = addedById;
    _roles = roles;
  }

  User.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    _addedById = json["added_by_id"];
    if (json["roles"] != null) {
      _roles = Role.fromJson(json["roles"]);
    }
  }
}

/// id : 2
/// title : "User"
/// added_by_id : 1
/// pivot : {"user_id":4,"role_id":2}

/// user_id : 4
/// role_id : 2

class Pivot {
  int _userId;
  int _roleId;

  int get userId => _userId;
  int get roleId => _roleId;

  Pivot({int userId, int roleId}) {
    _userId = userId;
    _roleId = roleId;
  }

  Pivot.fromJson(dynamic json) {
    _userId = json["user_id"];
    _roleId = json["role_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["user_id"] = _userId;
    map["role_id"] = _roleId;
    return map;
  }
}
