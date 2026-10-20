class InspectionDraftModel {
  bool? success;
  String? message;
  List<InspectionDraftData>? data;
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  InspectionDraftModel({
    this.success,
    this.message,
    this.data,
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory InspectionDraftModel.fromJson(Map<String, dynamic> json) {
    return InspectionDraftModel(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List?)
          ?.map(
            (item) =>
                InspectionDraftData.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}

class InspectionDraftData {
  // Add inspection draft fields when the API returns actual data.

  InspectionDraftData();

  factory InspectionDraftData.fromJson(Map<String, dynamic> json) {
    return InspectionDraftData();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
