class InspectionCompletedModel {
  bool? success;
  String? message;
  List<InspectionCompletedData>? data;
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  InspectionCompletedModel({
    this.success,
    this.message,
    this.data,
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory InspectionCompletedModel.fromJson(Map<String, dynamic> json) {
    return InspectionCompletedModel(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List?)
          ?.map(
            (item) =>
                InspectionCompletedData.fromJson(item as Map<String, dynamic>),
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

class InspectionCompletedData {
  // Add fields when the API returns an actual completed inspection.

  InspectionCompletedData();

  factory InspectionCompletedData.fromJson(Map<String, dynamic> json) {
    return InspectionCompletedData();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
