class UserModel {
  bool? success;
  UserData? data;

  UserModel({this.success, this.data});

  // Convert JSON to Dart object
  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  // Convert Dart object to JSON
  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data?.toJson()};
  }
}

class UserData {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? role;

  UserData({this.id, this.name, this.email, this.phone, this.role});

  // Convert JSON to Dart object
  UserData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
  }

  // Convert Dart object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }
}
