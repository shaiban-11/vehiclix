class CompletedInspectionModel {
  bool? success;
  String? message;
  List<InspectionCompletedData>? data;
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  CompletedInspectionModel({
    this.success,
    this.message,
    this.data,
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory CompletedInspectionModel.fromJson(Map<String, dynamic> json) {
    return CompletedInspectionModel(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List?)
          ?.map((e) => InspectionCompletedData.fromJson(e))
          .toList(),
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }
}

class InspectionCompletedData {
  String? id;
  String? inspectionNo;
  CustomerData? customer;
  VehicleData? vehicle;
  InspectorData? inspector;
  InspectionTypeData? inspectionType;
  String? inspectionDate;
  num? overallScore;
  num? totalWeight;
  int? passCount;
  int? failCount;
  int? naCount;
  int? ncCount;
  String? status;
  num? completionPercentage;

  InspectionCompletedData({
    this.id,
    this.inspectionNo,
    this.customer,
    this.vehicle,
    this.inspector,
    this.inspectionType,
    this.inspectionDate,
    this.overallScore,
    this.totalWeight,
    this.passCount,
    this.failCount,
    this.naCount,
    this.ncCount,
    this.status,
    this.completionPercentage,
  });

  factory InspectionCompletedData.fromJson(Map<String, dynamic> json) {
    return InspectionCompletedData(
      id: json['_id']?.toString(),
      inspectionNo: json['inspection_no'],
      customer: json['customer_id'] != null
          ? CustomerData.fromJson(json['customer_id'])
          : null,
      vehicle: json['vehicle_id'] != null
          ? VehicleData.fromJson(json['vehicle_id'])
          : null,
      inspector: json['inspector_id'] != null
          ? InspectorData.fromJson(json['inspector_id'])
          : null,
      inspectionType: json['inspection_type_id'] != null
          ? InspectionTypeData.fromJson(json['inspection_type_id'])
          : null,
      inspectionDate: json['inspection_date'],
      overallScore: json['overall_score'],
      totalWeight: json['total_weight'],
      passCount: json['pass_count'],
      failCount: json['fail_count'],
      naCount: json['na_count'],
      ncCount: json['nc_count'],
      status: json['status'],
      completionPercentage: json['completion_percentage'],
    );
  }
}

class CustomerData {
  UserData? user;
  String? city;
  String? address;
  String? country;
  String? phoneNumber;

  CustomerData({
    this.user,
    this.city,
    this.address,
    this.country,
    this.phoneNumber,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      user: json['user_id'] != null ? UserData.fromJson(json['user_id']) : null,
      city: json['city'],
      address: json['address'],
      country: json['country'],
      phoneNumber: json['phone_number'],
    );
  }
}

class UserData {
  String? name;
  String? phone;

  UserData({this.name, this.phone});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(name: json['name'], phone: json['phone']);
  }
}

class VehicleData {
  String? name;
  String? image;
  String? plateNumber;
  String? vin;

  VehicleData({this.name, this.image, this.plateNumber, this.vin});

  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      name: json['name'],
      image: json['image'],
      plateNumber: json['plate_number'],
      vin: json['vin'],
    );
  }
}

class InspectorData {
  String? name;

  InspectorData({this.name});

  factory InspectorData.fromJson(Map<String, dynamic> json) {
    return InspectorData(name: json['name']);
  }
}

class InspectionTypeData {
  String? name;

  InspectionTypeData({this.name});

  factory InspectionTypeData.fromJson(Map<String, dynamic> json) {
    return InspectionTypeData(name: json['name']);
  }
}
