// lib/features/vehicle/data/models/brand_model.dart

class BrandResponse {
  bool? success;
  List<BrandData>? data;
  bool? hasMore;
  int? total;
  int? page;
  int? limit;

  BrandResponse({
    this.success,
    this.data,
    this.hasMore,
    this.total,
    this.page,
    this.limit,
  });

  BrandResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <BrandData>[];
      json['data'].forEach((v) {
        data!.add(BrandData.fromJson(v));
      });
    }
    hasMore = json['has_more'];
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
  }
}

class BrandData {
  String? id;
  String? name;

  BrandData({this.id, this.name});

  BrandData.fromJson(Map<String, dynamic> json) {
    id = json['_id']; // Assuming your DB uses _id
    name = json['name']; // Assuming the brand name field is 'name'
  }
}
