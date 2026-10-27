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
                (item) =>
                    VehicleModelData.fromJson(item as Map<String, dynamic>),
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

class VehicleModelData {
  String? id;
  String? name;

  VehicleModelData({this.id, this.name});

  factory VehicleModelData.fromJson(Map<String, dynamic> json) {
    debugPrint('VEHICLE MODEL JSON: $json');
    return VehicleModelData(
      id: json['_id']?.toString(),
      name: (json['model_name'] ?? json['name'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}
