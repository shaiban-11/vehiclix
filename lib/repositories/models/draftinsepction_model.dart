class DraftInspectionModel {
  final bool success;
  final String message;
  final List<DraftInspectionData> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  DraftInspectionModel({
    required this.success,
    required this.message,
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory DraftInspectionModel.fromJson(Map<String, dynamic> json) {
    return DraftInspectionModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is List
          ? (json['data'] as List)
                .whereType<Map>()
                .map(
                  (item) => DraftInspectionData.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : [],
      total: _toInt(json['total']),
      page: _toInt(json['page']),
      limit: _toInt(json['limit']),
      totalPages: _toInt(json['totalPages']),
    );
  }
}

// =====================================================
// DRAFT INSPECTION DATA
// =====================================================

class DraftInspectionData {
  final String id;
  final String inspectionNo;
  final DraftCustomerInfo? customer;
  final DraftVehicleInfo? vehicle;
  final DraftInspectorInfo? inspector;
  final DraftInspectionTypeInfo? inspectionType;
  final String? inspectionDate;
  final num overallScore;
  final num totalWeight;
  final int passCount;
  final int failCount;
  final int naCount;
  final int ncCount;
  final String status;
  final bool isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final num completionPercentage;

  DraftInspectionData({
    required this.id,
    required this.inspectionNo,
    this.customer,
    this.vehicle,
    this.inspector,
    this.inspectionType,
    this.inspectionDate,
    required this.overallScore,
    required this.totalWeight,
    required this.passCount,
    required this.failCount,
    required this.naCount,
    required this.ncCount,
    required this.status,
    required this.isDeleted,
    this.createdAt,
    this.updatedAt,
    required this.completionPercentage,
  });

  factory DraftInspectionData.fromJson(Map<String, dynamic> json) {
    return DraftInspectionData(
      id: json['_id']?.toString() ?? '',
      inspectionNo: json['inspection_no']?.toString() ?? '',
      customer: json['customer_id'] is Map
          ? DraftCustomerInfo.fromJson(
              Map<String, dynamic>.from(json['customer_id']),
            )
          : null,
      vehicle: json['vehicle_id'] is Map
          ? DraftVehicleInfo.fromJson(
              Map<String, dynamic>.from(json['vehicle_id']),
            )
          : null,
      inspector: json['inspector_id'] is Map
          ? DraftInspectorInfo.fromJson(
              Map<String, dynamic>.from(json['inspector_id']),
            )
          : null,
      inspectionType: json['inspection_type_id'] is Map
          ? DraftInspectionTypeInfo.fromJson(
              Map<String, dynamic>.from(json['inspection_type_id']),
            )
          : null,
      inspectionDate: json['inspection_date']?.toString(),
      overallScore: _toNum(json['overall_score']),
      totalWeight: _toNum(json['total_weight']),
      passCount: _toInt(json['pass_count']),
      failCount: _toInt(json['fail_count']),
      naCount: _toInt(json['na_count']),
      ncCount: _toInt(json['nc_count']),
      status: json['status']?.toString() ?? '',
      isDeleted: json['isDeleted'] == true,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      completionPercentage: _toNum(json['completion_percentage']),
    );
  }
}

// =====================================================
// CUSTOMER
// =====================================================

class DraftCustomerInfo {
  final String id;
  final DraftCustomerUserInfo? user;
  final String customerType;
  final String city;
  final String address;
  final String country;
  final String phoneNumber;
  final String whatsappNumber;
  final bool isDeleted;

  DraftCustomerInfo({
    required this.id,
    this.user,
    required this.customerType,
    required this.city,
    required this.address,
    required this.country,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.isDeleted,
  });

  factory DraftCustomerInfo.fromJson(Map<String, dynamic> json) {
    return DraftCustomerInfo(
      id: json['_id']?.toString() ?? '',
      user: json['user_id'] is Map
          ? DraftCustomerUserInfo.fromJson(
              Map<String, dynamic>.from(json['user_id']),
            )
          : null,
      customerType: json['customer_type']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      whatsappNumber: json['whatsapp_number']?.toString() ?? '',
      isDeleted: json['is_deleted'] == true,
    );
  }
}

class DraftCustomerUserInfo {
  final String id;
  final String name;
  final String phone;

  DraftCustomerUserInfo({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory DraftCustomerUserInfo.fromJson(Map<String, dynamic> json) {
    return DraftCustomerUserInfo(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }
}

// =====================================================
// VEHICLE
// =====================================================

class DraftVehicleInfo {
  final String id;
  final String name;
  final String image;
  final String plateNumber;
  final String vin;

  DraftVehicleInfo({
    required this.id,
    required this.name,
    required this.image,
    required this.plateNumber,
    required this.vin,
  });

  factory DraftVehicleInfo.fromJson(Map<String, dynamic> json) {
    return DraftVehicleInfo(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      plateNumber: json['plate_number']?.toString() ?? '',
      vin: json['vin']?.toString() ?? '',
    );
  }
}

// =====================================================
// INSPECTOR
// =====================================================

class DraftInspectorInfo {
  final String id;
  final String name;

  DraftInspectorInfo({required this.id, required this.name});

  factory DraftInspectorInfo.fromJson(Map<String, dynamic> json) {
    return DraftInspectorInfo(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

// =====================================================
// INSPECTION TYPE
// =====================================================

class DraftInspectionTypeInfo {
  final String id;
  final String name;

  DraftInspectionTypeInfo({required this.id, required this.name});

  factory DraftInspectionTypeInfo.fromJson(Map<String, dynamic> json) {
    return DraftInspectionTypeInfo(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

// =====================================================
// SAFE CONVERSION HELPERS
// =====================================================

num _toNum(dynamic value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
