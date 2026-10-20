class VehicleVarientsByBrandModel {
  bool? success;
  List<VehicleVarientsByBrandData>? data;
  bool? hasMore;
  int? total;
  int? page;
  int? limit;

  VehicleVarientsByBrandModel({
    this.success,
    this.data,
    this.hasMore,
    this.total,
    this.page,
    this.limit,
  });

  factory VehicleVarientsByBrandModel.fromJson(Map<String, dynamic> json) {
    return VehicleVarientsByBrandModel(
      success: json['success'] as bool?,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => VehicleVarientsByBrandData.fromJson(
                  Map<String, dynamic>.from(item),
                ),
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

class VehicleVarientsByBrandData {
  String? id;
  String? name;

  VehicleVarientsByBrandData({this.id, this.name});

  factory VehicleVarientsByBrandData.fromJson(Map<String, dynamic> json) {
    return VehicleVarientsByBrandData(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}
