class InspectionSubmitModel {
  final String customerId;
  final String vehicleId;
  final String inspectionTypeId;
  final String status;
  final List<InspectionRemark> remarks;

  InspectionSubmitModel({
    required this.customerId,
    required this.vehicleId,
    required this.inspectionTypeId,
    required this.status,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'vehicle_id': vehicleId,
      'inspection_type_id': inspectionTypeId,
      'status': status,
      'remarks': remarks.map((remark) => remark.toJson()).toList(),
    };
  }
}

class InspectionRemark {
  final String categoryId;
  final List<InspectionItem> items;

  InspectionRemark({required this.categoryId, required this.items});

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class InspectionItem {
  final String itemId;
  final String status;
  final List<String>? defects;
  final String? comment;
  final List<InspectionImage>? images;

  InspectionItem({
    required this.itemId,
    required this.status,
    this.defects,
    this.comment,
    this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'status': status,
      if (defects != null) 'defects': defects,
      if (comment != null && comment!.trim().isNotEmpty)
        'comment': comment!.trim(),
      if (images != null)
        'images': images!.map((image) => image.toJson()).toList(),
    };
  }
}

class InspectionImage {
  final String url;

  InspectionImage({required this.url});

  Map<String, dynamic> toJson() {
    return {'url': url};
  }
}
