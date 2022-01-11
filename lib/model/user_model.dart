class User_model {
  List<User> data;
  int statusCode;

  User_model({this.data, this.statusCode});

  User_model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <User>[];
      json['data'].forEach((v) {
        data.add(new User.fromJson(v));
      });
    }
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['status_code'] = this.statusCode;
    return data;
  }
}

class User {
  int id;
  String fname;
  String lname;
  String mobile_number;
  String password;
  String password_confirmation;
  String address_line_1;
  String address_line_2;
  String countries__id;
  String status;
  bool isSelect;
  String username;
  String email;
  String createdAt;
  String since;
  String deletedAt;
  String profilePicture;
  UserAuthority userAuthority;


  User(
      {this.id,
      this.fname,
      this.lname,
      this.mobile_number,
      this.password,
      this.password_confirmation,
      this.address_line_1,
      this.address_line_2,
      this.countries__id,
      this.status,
      this.isSelect,
      this.username,
      this.email,
      this.createdAt,
      this.since,
      this.deletedAt,
      this.profilePicture,
      this.userAuthority});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fname = json['name'];
    username = json['username'];
    email = json['email'];
    createdAt = json['created_at'];
    since = json['since'];
    deletedAt = json['deleted_at'];
    profilePicture = json['profile_picture'];
    userAuthority = json['userAuthority'] != null
        ? new UserAuthority.fromJson(json['userAuthority'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.fname;
    data['last_name'] = this.lname;
    data['username'] = this.username;
    data['mobile_number'] = this.mobile_number;
    data['email'] = this.email;
    data['password'] = this.password;
    data['password_confirmation'] = this.password_confirmation;
    data['address_line_1'] = this.address_line_1;
    data['address_line_2'] = this.address_line_2;
    data['countries__id'] = this.countries__id;
    data['status'] = this.status;

    return data;
  }
}

class UserAuthority {
  int id;
  RoleName roleName;

  UserAuthority({this.id, this.roleName});

  UserAuthority.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleName = json['role_name'] != null
        ? new RoleName.fromJson(json['role_name'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.roleName != null) {
      data['role_name'] = this.roleName.toJson();
    }
    return data;
  }
}

class RoleName {
  int id;
  String title;

  RoleName({this.id, this.title});

  RoleName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}
