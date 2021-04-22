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
  int _id;
  String _name;
  String _email;
  int _addedById;
  Roles _roles;

  int get id => _id;
  String get name => _name;
  String get email => _email;
  int get addedById => _addedById;
  Roles get roles => _roles;

  User({int id, String name, String email, int addedById, Roles roles}) {
    _id = id;
    _name = name;
    _email = email;
    _addedById = addedById;
    _roles = roles;
  }

  User.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _email = json["email"];
    _addedById = json["added_by_id"];
    if (json["roles"] != null) {
        _roles=Roles.fromJson(json["roles"]);

    }
  }

}

/// id : 2
/// title : "User"
/// added_by_id : 1
/// pivot : {"user_id":4,"role_id":2}

class Roles {
  int _id;
  String _title;
  int _addedById;
  Pivot _pivot;

  int get id => _id;
  String get title => _title;
  int get addedById => _addedById;
  Pivot get pivot => _pivot;

  Roles({int id, String title, int addedById, Pivot pivot}) {
    _id = id;
    _title = title;
    _addedById = addedById;
    _pivot = pivot;
  }

  Roles.fromJson(dynamic json) {
    _id = json["id"];
    _title = json["title"];
    _addedById = json["added_by_id"];
    _pivot = json["pivot"] != null ? Pivot.fromJson(json["pivot"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["title"] = _title;
    map["added_by_id"] = _addedById;
    if (_pivot != null) {
      map["pivot"] = _pivot.toJson();
    }
    return map;
  }
}

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
