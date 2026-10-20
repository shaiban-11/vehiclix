class VehicleByBrandModel {
  bool? success;
  List<VehicleByBrandData>? data;
  bool? hasMore;
  int? total;
  int? page;
  int? limit;

  VehicleByBrandModel({
    this.success,
    this.data,
    this.hasMore,
    this.total,
    this.page,
    this.limit,
  });

  factory VehicleByBrandModel.fromJson(Map<String, dynamic> json) {
    return VehicleByBrandModel(
      success: json['success'] as bool?,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    VehicleByBrandData.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      hasMore: json['has_more'] as bool?,
      total: json['total'] as int?,
      page: json['page'] as int?,
      limit: json['limit'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((item) => item.toJson()).toList(),
      'has_more': hasMore,
      'total': total,
      'page': page,
      'limit': limit,
    };
  }
}

class VehicleByBrandData {
  String? id;
  String? name;

  VehicleByBrandData({this.id, this.name});

  factory VehicleByBrandData.fromJson(Map<String, dynamic> json) {
    return VehicleByBrandData(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}
