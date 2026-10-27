class BrandResponse {
  bool? success;
  String? message;
  List<BrandData> data;
  bool? hasMore;
  int? total;
  int? page;
  int? limit;

  BrandResponse({
    this.success,
    this.message,
    List<BrandData>? data,
    this.hasMore,
    this.total,
    this.page,
    this.limit,
  }) : data = data ?? [];

  factory BrandResponse.fromJson(Map<String, dynamic> json) {
    return BrandResponse(
      success: json['success'] as bool?,
      message: json['message']?.toString(),
      data: json['data'] is List
          ? (json['data'] as List)
                .whereType<Map>()
                .map(
                  (item) => BrandData.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : [],
      hasMore: json['has_more'] as bool?,
      total: json['total'] is num ? (json['total'] as num).toInt() : null,
      page: json['page'] is num ? (json['page'] as num).toInt() : null,
      limit: json['limit'] is num ? (json['limit'] as num).toInt() : null,
    );
  }
}

class BrandData {
  String? id;
  String? name;

  BrandData({this.id, this.name});

  factory BrandData.fromJson(Map<String, dynamic> json) {
    return BrandData(
      id: (json['_id'] ?? json['id'])?.toString(),
      name: (json['name'] ?? json['brand_name'])?.toString(),
    );
  }
}
