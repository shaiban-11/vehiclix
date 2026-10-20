class VehicleVarientsModel {
  bool? success;
  List<VehicleVarientsData>? data;
  bool? hasMore;
  int? total;
  int? page;
  int? limit;

  VehicleVarientsModel({
    this.success,
    this.data,
    this.hasMore,
    this.total,
    this.page,
    this.limit,
  });

  factory VehicleVarientsModel.fromJson(Map<String, dynamic> json) {
    return VehicleVarientsModel(
      success: json['success'] as bool?,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => VehicleVarientsData.fromJson(
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

class VehicleVarientsData {
  String? id;
  String? name;

  VehicleVarientsData({this.id, this.name});

  factory VehicleVarientsData.fromJson(Map<String, dynamic> json) {
    return VehicleVarientsData(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}
