class CustomerProfileModel {
  bool? success;
  String? message;
  CustomerProfileData? data;

  CustomerProfileModel({this.success, this.message, this.data});

  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) {
    return CustomerProfileModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? CustomerProfileData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class CustomerProfileData {
  CustomerUser? user;
  CustomerProfile? profile;

  CustomerProfileData({this.user, this.profile});

  factory CustomerProfileData.fromJson(Map<String, dynamic> json) {
    return CustomerProfileData(
      user: json['user'] != null ? CustomerUser.fromJson(json['user']) : null,
      profile: json['profile'] != null
          ? CustomerProfile.fromJson(json['profile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user?.toJson(), 'profile': profile?.toJson()};
  }
}

class CustomerUser {
  String? id;
  String? name;
  String? userType;
  String? phone;
  String? email;
  bool? status;
  String? lastLogin;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? version;

  CustomerUser({
    this.id,
    this.name,
    this.userType,
    this.phone,
    this.email,
    this.status,
    this.lastLogin,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory CustomerUser.fromJson(Map<String, dynamic> json) {
    return CustomerUser(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      userType: json['user_type']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      status: json['status'],
      lastLogin: json['last_login']?.toString(),
      isDeleted: json['is_deleted'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'user_type': userType,
      'phone': phone,
      'email': email,
      'status': status,
      'last_login': lastLogin,
      'is_deleted': isDeleted,
      'created_at': createdAt,
      'updated_at': updatedAt,
      '__v': version,
    };
  }
}

class CustomerProfile {
  String? id;
  String? userId;
  String? customerType;
  String? city;
  String? address;
  String? country;
  String? phoneNumber;
  String? whatsappNumber;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? version;

  CustomerProfile({
    this.id,
    this.userId,
    this.customerType,
    this.city,
    this.address,
    this.country,
    this.phoneNumber,
    this.whatsappNumber,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json['_id']?.toString(),
      userId: json['user_id']?.toString(),
      customerType: json['customer_type']?.toString(),
      city: json['city']?.toString(),
      address: json['address']?.toString(),
      country: json['country']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      whatsappNumber: json['whatsapp_number']?.toString(),
      isDeleted: json['is_deleted'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'customer_type': customerType,
      'city': city,
      'address': address,
      'country': country,
      'phone_number': phoneNumber,
      'whatsapp_number': whatsappNumber,
      'is_deleted': isDeleted,
      'created_at': createdAt,
      'updated_at': updatedAt,
      '__v': version,
    };
  }
}
