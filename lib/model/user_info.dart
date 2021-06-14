class UserInformation {
  Data data;

  UserInformation({this.data});

  UserInformation.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String status;
  UserInfo user;

  Data({this.status, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? new UserInfo.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class UserInfo {
  int id;
  String name;
  String email;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int addedById;
  int rolesid;
  String lang;
  String lastName;
  String phoneNo;
  String birthdate;
  String gender;
  String facebookId;
  String facebookAvatar;
  String password;
  String passwordConfirmation;
  List<Roles> roles;

  UserInfo(
      {this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.addedById,
        this.lang,
        this.lastName,
        this.phoneNo,
        this.birthdate,
        this.gender,
        this.facebookId,
        this.facebookAvatar,
        this.roles});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    addedById = json['added_by_id'];
    lang = json['lang'];
    lastName = json['last_name'];
    phoneNo = json['phone_no'];
    birthdate = json['birthdate'];
    gender = json['gender'];
    facebookId = json['facebook_id'];
    facebookAvatar = json['facebook_avatar'];
    if (json['roles'] != null) {
      roles = new List<Roles>();
      json['roles'].forEach((v) {
        roles.add(new Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['added_by_id'] = this.addedById;
    data['lang'] = this.lang;
    data['last_name'] = this.lastName;
    data['phone_no'] = this.phoneNo;
    data['birthdate'] = this.birthdate;
    data['gender'] = this.gender;
    data['facebook_id'] = this.facebookId;
    data['facebook_avatar'] = this.facebookAvatar;
    data['roles'] = this.rolesid;

    return data;
  }
}

class Roles {
  int id;
  String title;
  String createdAt;
  String updatedAt;
  int addedById;
  String lang;
  Pivot pivot;
  List<Permissions> permissions;

  Roles(
      {this.id,
        this.title,
        this.createdAt,
        this.updatedAt,
        this.addedById,
        this.lang,
        this.pivot,
        this.permissions});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    addedById = json['added_by_id'];
    lang = json['lang'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
    if (json['permissions'] != null) {
      permissions = new List<Permissions>();
      json['permissions'].forEach((v) {
        permissions.add(new Permissions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['added_by_id'] = this.addedById;
    data['lang'] = this.lang;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    if (this.permissions != null) {
      data['permissions'] = this.permissions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pivot {
  int userId;
  int roleId;

  Pivot({this.userId, this.roleId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['role_id'] = this.roleId;
    return data;
  }
}

class Permissions {
  int id;
  String title;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  Pivot pivot;

  Permissions(
      {this.id,
        this.title,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.pivot});

  Permissions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    return data;
  }
}

