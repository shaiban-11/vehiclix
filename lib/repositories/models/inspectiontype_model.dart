class InspectionTypeModel {
  bool? success;
  List<InspectionTypeData>? data;

  InspectionTypeModel({this.success, this.data});

  factory InspectionTypeModel.fromJson(Map<String, dynamic> json) {
    return InspectionTypeModel(
      success: json['success'],
      data: (json['data'] as List?)
          ?.map(
            (item) => InspectionTypeData.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class InspectionTypeData {
  // Add fields here when the API returns actual inspection type data.

  InspectionTypeData();

  factory InspectionTypeData.fromJson(Map<String, dynamic> json) {
    return InspectionTypeData();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
