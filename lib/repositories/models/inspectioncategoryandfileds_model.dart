class InspectionDetailsModel {
  bool? success;
  InspectionDetailsData? data;

  InspectionDetailsModel({this.success, this.data});

  factory InspectionDetailsModel.fromJson(Map<String, dynamic> json) {
    return InspectionDetailsModel(
      success: json['success'] as bool?,
      data: json['data'] is Map
          ? InspectionDetailsData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data?.toJson()};
  }
}

class InspectionDetailsData {
  String? id;
  InspectionTypeInfo? inspectionTypeId;
  List<dynamic> categories;

  InspectionDetailsData({
    this.id,
    this.inspectionTypeId,
    this.categories = const [],
  });

  factory InspectionDetailsData.fromJson(Map<String, dynamic> json) {
    return InspectionDetailsData(
      id: json['_id']?.toString(),
      inspectionTypeId: json['inspectionTypeId'] is Map
          ? InspectionTypeInfo.fromJson(
              Map<String, dynamic>.from(json['inspectionTypeId'] as Map),
            )
          : null,
      categories: json['categories'] is List
          ? List<dynamic>.from(json['categories'] as List)
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'inspectionTypeId': inspectionTypeId?.toJson(),
      'categories': categories,
    };
  }
}

class InspectionTypeInfo {
  String? id;
  String? name;

  InspectionTypeInfo({this.id, this.name});

  factory InspectionTypeInfo.fromJson(Map<String, dynamic> json) {
    return InspectionTypeInfo(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}
