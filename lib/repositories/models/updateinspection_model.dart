class InspectionUpdateModel {
  bool? success;
  String? message;
  InspectionUpdateData? data;

  InspectionUpdateModel({this.success, this.message, this.data});

  factory InspectionUpdateModel.fromJson(Map<String, dynamic> json) {
    return InspectionUpdateModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? InspectionUpdateData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class InspectionUpdateData {
  String? id;
  String? inspectionNo;
  String? customerId;
  String? vehicleId;
  String? inspectorId;
  String? inspectionTypeId;
  String? inspectionDate;
  num? overallScore;
  num? totalWeight;
  int? passCount;
  int? failCount;
  int? naCount;
  int? ncCount;
  String? status;
  List<InspectionRemark>? remarks;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? v;

  InspectionUpdateData({
    this.id,
    this.inspectionNo,
    this.customerId,
    this.vehicleId,
    this.inspectorId,
    this.inspectionTypeId,
    this.inspectionDate,
    this.overallScore,
    this.totalWeight,
    this.passCount,
    this.failCount,
    this.naCount,
    this.ncCount,
    this.status,
    this.remarks,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory InspectionUpdateData.fromJson(Map<String, dynamic> json) {
    return InspectionUpdateData(
      id: json['_id'],
      inspectionNo: json['inspection_no'],
      customerId: json['customer_id'],
      vehicleId: json['vehicle_id'],
      inspectorId: json['inspector_id'],
      inspectionTypeId: json['inspection_type_id'],
      inspectionDate: json['inspection_date'],
      overallScore: json['overall_score'],
      totalWeight: json['total_weight'],
      passCount: json['pass_count'],
      failCount: json['fail_count'],
      naCount: json['na_count'],
      ncCount: json['nc_count'],
      status: json['status'],
      remarks: json['remarks'] != null
          ? (json['remarks'] as List)
                .map((e) => InspectionRemark.fromJson(e))
                .toList()
          : [],
      isDeleted: json['isDeleted'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'inspection_no': inspectionNo,
      'customer_id': customerId,
      'vehicle_id': vehicleId,
      'inspector_id': inspectorId,
      'inspection_type_id': inspectionTypeId,
      'inspection_date': inspectionDate,
      'overall_score': overallScore,
      'total_weight': totalWeight,
      'pass_count': passCount,
      'fail_count': failCount,
      'na_count': naCount,
      'nc_count': ncCount,
      'status': status,
      'remarks': remarks?.map((e) => e.toJson()).toList(),
      'isDeleted': isDeleted,
      'created_at': createdAt,
      'updated_at': updatedAt,
      '__v': v,
    };
  }
}

class InspectionRemark {
  String? categoryId;
  List<InspectionRemarkItem>? items;

  InspectionRemark({this.categoryId, this.items});

  factory InspectionRemark.fromJson(Map<String, dynamic> json) {
    return InspectionRemark(
      categoryId: json['categoryId'],
      items: json['items'] != null
          ? (json['items'] as List)
                .map((e) => InspectionRemarkItem.fromJson(e))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'items': items?.map((e) => e.toJson()).toList(),
    };
  }
}

class InspectionRemarkItem {
  String? itemId;
  List<String>? defects;
  String? comment;
  String? status;
  List<InspectionImage>? images;
  num? weight;

  InspectionRemarkItem({
    this.itemId,
    this.defects,
    this.comment,
    this.status,
    this.images,
    this.weight,
  });

  factory InspectionRemarkItem.fromJson(Map<String, dynamic> json) {
    return InspectionRemarkItem(
      itemId: json['itemId'],
      defects: json['defects'] != null
          ? List<String>.from(json['defects'])
          : [],
      comment: json['comment'],
      status: json['status'],
      images: json['images'] != null
          ? (json['images'] as List)
                .map((e) => InspectionImage.fromJson(e))
                .toList()
          : [],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'defects': defects,
      'comment': comment,
      'status': status,
      'images': images?.map((e) => e.toJson()).toList(),
      'weight': weight,
    };
  }
}

class InspectionImage {
  String? url;
  String? id;

  InspectionImage({this.url, this.id});

  factory InspectionImage.fromJson(Map<String, dynamic> json) {
    return InspectionImage(url: json['url'], id: json['_id']);
  }

  Map<String, dynamic> toJson() {
    return {'url': url, '_id': id};
  }
}
