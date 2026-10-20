
class LoginModel {
  bool? success;
  String? message;
  Data? data;

  LoginModel({
    this.success,
    this.message,
    this.data,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? Data.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class Data {
  User? user;
  String? accessToken;
  String? refreshToken;

  Data({
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null
        ? User.fromJson(json['user'])
        : null;
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

class User {
  String? id;
  String? name;
  RoleId? roleId;
  String? userType;
  String? phone;
  String? email;
  bool? status;
  String? lastLogin;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? v;

  User({
    this.id,
    this.name,
    this.roleId,
    this.userType,
    this.phone,
    this.email,
    this.status,
    this.lastLogin,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    roleId = json['role_id'] != null
        ? RoleId.fromJson(json['role_id'])
        : null;
    userType = json['user_type'];
    phone = json['phone'];
    email = json['email'];
    status = json['status'];
    lastLogin = json['last_login'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'role_id': roleId?.toJson(),
      'user_type': userType,
      'phone': phone,
      'email': email,
      'status': status,
      'last_login': lastLogin,
      'is_deleted': isDeleted,
      'created_at': createdAt,
      'updated_at': updatedAt,
      '__v': v,
    };
  }
}

class RoleId {
  String? id;
  String? role;
  bool? isDeleted;
  bool? isSystem;
  bool? status;
  List<dynamic>? permissions;
  String? createdAt;
  String? updatedAt;
  int? v;

  RoleId({
    this.id,
    this.role,
    this.isDeleted,
    this.isSystem,
    this.status,
    this.permissions,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  RoleId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    role = json['role'];
    isDeleted = json['is_deleted'];
    isSystem = json['is_system'];
    status = json['status'];
    permissions = json['permissions'] != null
        ? List<dynamic>.from(json['permissions'])
        : [];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'role': role,
      'is_deleted': isDeleted,
      'is_system': isSystem,
      'status': status,
      'permissions': permissions,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
