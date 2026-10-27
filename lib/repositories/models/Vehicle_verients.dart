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

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data?.map((item) => item.toJson()).toList(),
    'has_more': hasMore,
    'total': total,
    'page': page,
    'limit': limit,
  };
}

class VehicleVarientsData {
  String? id;
  String? modelId;
  String? variantName;

  VehicleVarientsData({this.id, this.modelId, this.variantName});

  factory VehicleVarientsData.fromJson(Map<String, dynamic> json) {
    return VehicleVarientsData(
      id: json['_id']?.toString(),
      modelId: json['model_id']?.toString(),
      variantName: json['variant_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'model_id': modelId,
    'variant_name': variantName,
  };
}
