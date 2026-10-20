class FuelTypesResponse {
  bool? success;
  List<FuelTypeData>? data;

  FuelTypesResponse({this.success, this.data});

  factory FuelTypesResponse.fromJson(Map<String, dynamic> json) {
    return FuelTypesResponse(
      success: json['success'] as bool?,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => FuelTypeData.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class FuelTypeData {
  String? id;
  String? name;

  FuelTypeData({this.id, this.name});

  factory FuelTypeData.fromJson(Map<String, dynamic> json) {
    return FuelTypeData(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}
