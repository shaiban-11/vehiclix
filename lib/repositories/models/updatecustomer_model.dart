class CustomerUpdateModel {
  final bool? success;
  final String? message;
  final CustomerUpdateData? data;

  CustomerUpdateModel({this.success, this.message, this.data});

  factory CustomerUpdateModel.fromJson(Map<String, dynamic> json) {
    return CustomerUpdateModel(
      success: json['success'] as bool?,
      message: json['message']?.toString(),
      data: json['data'] is Map
          ? CustomerUpdateData.fromJson(Map<String, dynamic>.from(json['data']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class CustomerUpdateData {
  final String? id;
  final CustomerUpdateUser? user;
  final String? customerType;
  final String? city;
  final String? address;
  final String? country;
  final String? phoneNumber;
  final String? whatsappNumber;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final int? version;

  CustomerUpdateData({
    this.id,
    this.user,
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

  factory CustomerUpdateData.fromJson(Map<String, dynamic> json) {
    return CustomerUpdateData(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      user: json['user_id'] is Map
          ? CustomerUpdateUser.fromJson(
              Map<String, dynamic>.from(json['user_id']),
            )
          : null,
      customerType: json['customer_type']?.toString(),
      city: json['city']?.toString(),
      address: json['address']?.toString(),
      country: json['country']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      whatsappNumber: json['whatsapp_number']?.toString(),
      isDeleted: json['is_deleted'] as bool?,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      version: json['__v'] is int
          ? json['__v'] as int
          : int.tryParse(json['__v']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': user?.toJson(),
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

class CustomerUpdateUser {
  final String? id;
  final String? name;
  final String? userType;
  final String? phone;
  final String? email;
  final bool? status;

  CustomerUpdateUser({
    this.id,
    this.name,
    this.userType,
    this.phone,
    this.email,
    this.status,
  });

  factory CustomerUpdateUser.fromJson(Map<String, dynamic> json) {
    return CustomerUpdateUser(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      name: json['name']?.toString(),
      userType: json['user_type']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      status: json['status'] as bool?,
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
    };
  }
}
