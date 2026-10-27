class CustomerModel {
  bool? success;
  List<CustomerData>? data;
  bool? hasMore;
  int? total;
  int? page;
  int? limit;

  CustomerModel({
    this.success,
    this.data,
    this.hasMore,
    this.total,
    this.page,
    this.limit,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    return CustomerModel(
      success: json['success'] as bool?,
      data: rawData is List
          ? rawData
                .whereType<Map>()
                .map(
                  (item) =>
                      CustomerData.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : <CustomerData>[],
      hasMore: json['has_more'] as bool?,
      total: _toInt(json['total']),
      page: _toInt(json['page']),
      limit: _toInt(json['limit']),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data?.map((item) => item.toJson()).toList(),
    'has_more': hasMore,
    'total': total,
    'page': page,
    'limit': limit,
  };
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '');
}

class CustomerData {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? whatsappNumber;
  String? customerType;

  CustomerData({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.whatsappNumber,
    this.customerType,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    // API response uses user_id, which contains the customer details.
    final user = json['user_id'] is Map
        ? Map<String, dynamic>.from(json['user_id'])
        : json['user'] is Map
        ? Map<String, dynamic>.from(json['user'])
        : <String, dynamic>{};

    final profile = json['profile'] is Map
        ? Map<String, dynamic>.from(json['profile'])
        : <String, dynamic>{};

    String? readValue(List<dynamic> values) {
      for (final value in values) {
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
      return null;
    }

    return CustomerData(
      // MongoDB commonly returns _id instead of id.
      id: readValue([json['_id'], json['id'], json['customer_id']]),
      name: readValue([
        json['name'],
        json['customer_name'],
        user['name'],
        profile['name'],
      ]),
      email: readValue([json['email'], user['email'], profile['email']]),
      phone: readValue([
        json['phone'],
        json['mobile'],
        json['phone_number'],
        user['phone'],
        user['mobile'],
        user['phone_number'],
        profile['phone'],
        profile['phone_number'],
      ]),
      whatsappNumber: readValue([
        json['whatsapp_number'],
        json['whatsapp'],
        user['whatsapp_number'],
        profile['whatsapp_number'],
      ]),
      customerType: readValue([
        json['customer_type'],
        profile['customer_type'],
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'whatsapp_number': whatsappNumber,
    'customer_type': customerType,
  };
}
