class InspectionDetailsModel {
  final bool? success;
  final InspectionDetailsData? data;

  InspectionDetailsModel({this.success, this.data});

  factory InspectionDetailsModel.fromJson(Map<String, dynamic> json) {
    return InspectionDetailsModel(
      success: json['success'] as bool?,
      data: json['data'] is Map
          ? InspectionDetailsData.fromJson(
              Map<String, dynamic>.from(json['data']),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {'success': success, 'data': data?.toJson()};
}

class InspectionDetailsData {
  final String? id;
  final InspectionTypeInfo? inspectionTypeId;
  final List<InspectionCategory> categories;

  InspectionDetailsData({
    this.id,
    this.inspectionTypeId,
    this.categories = const [],
  });

  factory InspectionDetailsData.fromJson(Map<String, dynamic> json) {
    return InspectionDetailsData(
      id: json['_id']?.toString(),
      inspectionTypeId: json['inspectionTypeId'] is Map
          ? InspectionTypeInfo.fromJson(
              Map<String, dynamic>.from(json['inspectionTypeId']),
            )
          : null,
      categories: (json['categories'] as List? ?? [])
          .whereType<Map>()
          .map((e) => InspectionCategory.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'inspectionTypeId': inspectionTypeId?.toJson(),
    'categories': categories.map((e) => e.toJson()).toList(),
  };
}

class InspectionTypeInfo {
  final String? id;
  final String? name;

  InspectionTypeInfo({this.id, this.name});

  factory InspectionTypeInfo.fromJson(Map<String, dynamic> json) {
    return InspectionTypeInfo(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name};
}

class InspectionCategory {
  final InspectionCategoryInfo? categoryId;
  final int? order;
  final List<InspectionCategoryItem> items;

  InspectionCategory({this.categoryId, this.order, this.items = const []});

  factory InspectionCategory.fromJson(Map<String, dynamic> json) {
    return InspectionCategory(
      categoryId: json['categoryId'] is Map
          ? InspectionCategoryInfo.fromJson(
              Map<String, dynamic>.from(json['categoryId']),
            )
          : null,
      order: (json['order'] as num?)?.toInt(),
      items: (json['items'] as List? ?? [])
          .whereType<Map>()
          .map(
            (e) =>
                InspectionCategoryItem.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId?.toJson(),
    'order': order,
    'items': items.map((e) => e.toJson()).toList(),
  };
}

class InspectionCategoryInfo {
  final String? id;
  final String? name;
  final bool? isSystem;
  final bool? isTemplate;

  InspectionCategoryInfo({this.id, this.name, this.isSystem, this.isTemplate});

  factory InspectionCategoryInfo.fromJson(Map<String, dynamic> json) {
    return InspectionCategoryInfo(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      isSystem: json['is_system'] as bool?,
      isTemplate: json['is_template'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'is_system': isSystem,
    'is_template': isTemplate,
  };
}

class InspectionCategoryItem {
  final InspectionItemInfo? itemId;
  final int? order;

  InspectionCategoryItem({this.itemId, this.order});

  factory InspectionCategoryItem.fromJson(Map<String, dynamic> json) {
    return InspectionCategoryItem(
      itemId: json['itemId'] is Map
          ? InspectionItemInfo.fromJson(
              Map<String, dynamic>.from(json['itemId']),
            )
          : null,
      order: (json['order'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {'itemId': itemId?.toJson(), 'order': order};
}

class InspectionItemInfo {
  final String? id;
  final String? categoryId;
  final String? name;
  final String? code;
  final bool? isRequired;
  final bool? hasPhoto;
  final bool? hasRemark;
  final num? weight;
  final bool? isSystem;
  final String? fieldType;
  final List<dynamic> defects;
  final String? imageUrl;

  InspectionItemInfo({
    this.id,
    this.categoryId,
    this.name,
    this.code,
    this.isRequired,
    this.hasPhoto,
    this.hasRemark,
    this.weight,
    this.isSystem,
    this.fieldType,
    this.defects = const [],
    this.imageUrl,
  });

  factory InspectionItemInfo.fromJson(Map<String, dynamic> json) {
    return InspectionItemInfo(
      id: json['_id']?.toString(),
      categoryId: json['categoryId']?.toString(),
      name: json['name']?.toString(),
      code: json['code']?.toString(),
      isRequired: json['isRequired'] as bool?,
      hasPhoto: json['hasPhoto'] as bool?,
      hasRemark: json['hasRemark'] as bool?,
      weight: json['weight'] as num?,
      isSystem: json['is_system'] as bool?,
      fieldType: json['fieldType']?.toString(),
      defects: json['defects'] as List? ?? [],
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'categoryId': categoryId,
    'name': name,
    'code': code,
    'isRequired': isRequired,
    'hasPhoto': hasPhoto,
    'hasRemark': hasRemark,
    'weight': weight,
    'is_system': isSystem,
    'fieldType': fieldType,
    'defects': defects,
    'image_url': imageUrl,
  };
}
