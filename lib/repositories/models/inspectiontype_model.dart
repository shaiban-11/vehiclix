class InspectionModel {
  bool? success;
  List<InspectionData>? data;

  InspectionModel({this.success, this.data});

  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    return InspectionModel(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List)
                .map((item) => InspectionData.fromJson(item))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class InspectionData {
  String? id;
  String? name;

  InspectionData({this.id, this.name});

  factory InspectionData.fromJson(Map<String, dynamic> json) {
    return InspectionData(id: json['_id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}
