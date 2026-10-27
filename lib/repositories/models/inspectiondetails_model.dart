class VehicleInspectionModel {
  final bool success;
  final String message;
  final InspectionData? data;

  VehicleInspectionModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory VehicleInspectionModel.fromJson(Map<String, dynamic> json) {
    return VehicleInspectionModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map
          ? InspectionData.fromJson(Map<String, dynamic>.from(json['data']))
          : null,
    );
  }
}

// =====================================================
// INSPECTION DATA
// =====================================================

class InspectionData {
  final String id;
  final String inspectionNo;
  final CustomerInfo? customer;
  final VehicleInfo? vehicle;
  final InspectorInfo? inspector;
  final String? inspectionDate;
  final num overallScore;
  final num totalWeight;
  final num gainedScore;
  final int passCount;
  final int failCount;
  final int naCount;
  final int ncCount;
  final String status;
  final List<dynamic> electrical;
  final InspectionTypeInfo? inspectionType;
  final String? inspectionTypeId;
  final List<InspectionCategory> categories;

  InspectionData({
    required this.id,
    required this.inspectionNo,
    this.customer,
    this.vehicle,
    this.inspector,
    this.inspectionDate,
    required this.overallScore,
    required this.totalWeight,
    required this.gainedScore,
    required this.passCount,
    required this.failCount,
    required this.naCount,
    required this.ncCount,
    required this.status,
    required this.electrical,
    this.inspectionType,
    this.inspectionTypeId,
    required this.categories,
  });

  factory InspectionData.fromJson(Map<String, dynamic> json) {
    return InspectionData(
      id: json['_id']?.toString() ?? '',
      inspectionNo: json['inspection_no']?.toString() ?? '',
      customer: json['customer_id'] is Map
          ? CustomerInfo.fromJson(
              Map<String, dynamic>.from(json['customer_id']),
            )
          : null,
      vehicle: json['vehicle_id'] is Map
          ? VehicleInfo.fromJson(Map<String, dynamic>.from(json['vehicle_id']))
          : null,
      inspector: json['inspector_id'] is Map
          ? InspectorInfo.fromJson(
              Map<String, dynamic>.from(json['inspector_id']),
            )
          : null,
      inspectionDate: json['inspection_date']?.toString(),
      overallScore: _number(json['overall_score']),
      totalWeight: _number(json['total_weight']),
      gainedScore: _number(json['gained_score']),
      passCount: _integer(json['pass_count']),
      failCount: _integer(json['fail_count']),
      naCount: _integer(json['na_count']),
      ncCount: _integer(json['nc_count']),
      status: json['status']?.toString() ?? '',
      electrical: json['electrical'] is List
          ? List<dynamic>.from(json['electrical'])
          : [],
      inspectionType: json['inspectionTypeId'] is Map
          ? InspectionTypeInfo.fromJson(
              Map<String, dynamic>.from(json['inspectionTypeId']),
            )
          : null,
      inspectionTypeId: json['inspection_type_id'] is Map
          ? json['inspection_type_id']['_id']?.toString()
          : json['inspection_type_id']?.toString(),
      categories: json['categories'] is List
          ? (json['categories'] as List)
                .whereType<Map>()
                .map(
                  (e) =>
                      InspectionCategory.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList()
          : [],
    );
  }
}

// =====================================================
// CUSTOMER
// =====================================================

class CustomerInfo {
  final String id;
  final CustomerUserInfo? user;
  final String customerType;
  final String city;
  final String address;
  final String country;
  final String phoneNumber;
  final String whatsappNumber;
  final bool isDeleted;
  final String? createdAt;
  final String? updatedAt;

  CustomerInfo({
    required this.id,
    this.user,
    required this.customerType,
    required this.city,
    required this.address,
    required this.country,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      id: json['_id']?.toString() ?? '',
      user: json['user_id'] is Map
          ? CustomerUserInfo.fromJson(
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
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

class CustomerUserInfo {
  final String id;
  final String name;
  final String phone;

  CustomerUserInfo({required this.id, required this.name, required this.phone});

  factory CustomerUserInfo.fromJson(Map<String, dynamic> json) {
    return CustomerUserInfo(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }
}

// =====================================================
// VEHICLE
// =====================================================

class VehicleInfo {
  final String id;
  final VehicleReference? brand;
  final VehicleReference? model;
  final VehicleReference? variant;
  final int year;
  final String vin;
  final String plateNumber;
  final String engineNumber;
  final VehicleReference? fuelType;
  final VehicleReference? transmission;
  final num odometer;
  final bool spareTyre;
  final VehicleReference? countrySpec;
  final List<dynamic> vehicleImages;

  VehicleInfo({
    required this.id,
    this.brand,
    this.model,
    this.variant,
    required this.year,
    required this.vin,
    required this.plateNumber,
    required this.engineNumber,
    this.fuelType,
    this.transmission,
    required this.odometer,
    required this.spareTyre,
    this.countrySpec,
    required this.vehicleImages,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      id: json['_id']?.toString() ?? '',
      brand: _reference(json['brand_id']),
      model: _reference(json['model_id']),
      variant: _reference(json['variant_id']),
      year: _integer(json['year']),
      vin: json['vin']?.toString() ?? '',
      plateNumber: json['plate_number']?.toString() ?? '',
      engineNumber: json['engine_number']?.toString() ?? '',
      fuelType: _reference(json['fuel_type_id']),
      transmission: _reference(json['transmission_id']),
      odometer: _number(json['odometer']),
      spareTyre: json['spare_tyre'] == true,
      countrySpec: _reference(json['country_spec']),
      vehicleImages: json['vehicle_images'] is List
          ? List<dynamic>.from(json['vehicle_images'])
          : [],
    );
  }
}

class VehicleReference {
  final String id;
  final String name;

  VehicleReference({required this.id, required this.name});

  factory VehicleReference.fromJson(Map<String, dynamic> json) {
    return VehicleReference(
      id: json['_id']?.toString() ?? '',
      name:
          json['name']?.toString() ??
          json['model_name']?.toString() ??
          json['variant_name']?.toString() ??
          '',
    );
  }
}

VehicleReference? _reference(dynamic value) {
  if (value is Map) {
    return VehicleReference.fromJson(Map<String, dynamic>.from(value));
  }
  return null;
}

// =====================================================
// INSPECTOR
// =====================================================

class InspectorInfo {
  final String id;
  final String name;

  InspectorInfo({required this.id, required this.name});

  factory InspectorInfo.fromJson(Map<String, dynamic> json) {
    return InspectorInfo(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

// =====================================================
// INSPECTION TYPE
// =====================================================

class InspectionTypeInfo {
  final String id;
  final String name;

  InspectionTypeInfo({required this.id, required this.name});

  factory InspectionTypeInfo.fromJson(Map<String, dynamic> json) {
    return InspectionTypeInfo(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

// =====================================================
// CATEGORY
// =====================================================

class InspectionCategory {
  final VehicleReference? category;
  final int order;
  final List<InspectionItem> items;

  InspectionCategory({this.category, required this.order, required this.items});

  factory InspectionCategory.fromJson(Map<String, dynamic> json) {
    return InspectionCategory(
      category: _reference(json['categoryId']),
      order: _integer(json['order']),
      items: json['items'] is List
          ? (json['items'] as List)
                .whereType<Map>()
                .map(
                  (e) => InspectionItem.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList()
          : [],
    );
  }
}

// =====================================================
// INSPECTION ITEM
// =====================================================

class InspectionItem {
  final VehicleReference? item;
  final int order;
  final num weight;
  final String status;
  final String comment;
  final List<dynamic> images;
  final List<dynamic> selectedDefects;
  final List<dynamic> selectedDefectIds;
  final bool checked;

  InspectionItem({
    this.item,
    required this.order,
    required this.weight,
    required this.status,
    required this.comment,
    required this.images,
    required this.selectedDefects,
    required this.selectedDefectIds,
    required this.checked,
  });

  factory InspectionItem.fromJson(Map<String, dynamic> json) {
    return InspectionItem(
      item: _reference(json['itemId']),
      order: _integer(json['order']),
      weight: _number(json['weight']),
      status: json['status']?.toString() ?? '',
      comment: json['comment']?.toString() ?? '',
      images: json['images'] is List ? List<dynamic>.from(json['images']) : [],
      selectedDefects: json['selected_defects'] is List
          ? List<dynamic>.from(json['selected_defects'])
          : [],
      selectedDefectIds: json['selected_defect_ids'] is List
          ? List<dynamic>.from(json['selected_defect_ids'])
          : [],
      checked: json['checked'] == true,
    );
  }
}

// =====================================================
// SAFE NUMBER HELPERS
// =====================================================

num _number(dynamic value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}

int _integer(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
