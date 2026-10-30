import 'package:flutter/material.dart';

class VehicleModel {
  bool? success;
  List<VehicleModelData>? data;
  bool? hasMore;
  int? total;
  int? page;
  int? limit;

  VehicleModel({
    this.success,
    this.data,
    this.hasMore,
    this.total,
    this.page,
    this.limit,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      success: json['success'] as bool?,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => VehicleModelData.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          [],
      hasMore: json['has_more'] as bool?,
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
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

class VehicleModelData {
  String? id;
  String? name;
  String? brandId;

  VehicleModelData({this.id, this.name, this.brandId});

  factory VehicleModelData.fromJson(Map<String, dynamic> json) {
    debugPrint('VEHICLE MODEL JSON: $json');

    final brand = json['brand'];

    final dynamic brandValue =
        json['brand_id'] ??
        json['brandId'] ??
        (brand is Map ? (brand['_id'] ?? brand['id']) : brand);

    return VehicleModelData(
      id: (json['_id'] ?? json['id'])?.toString(),
      name: (json['model_name'] ?? json['name'])?.toString(),
      brandId: brandValue?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'model_name': name, 'brand_id': brandId};
  }
}
