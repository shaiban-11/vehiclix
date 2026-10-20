class TransmissionModel {
  bool? success;
  List<TransmissionModell>? data;

  TransmissionModel({this.success, this.data});

  factory TransmissionModel.fromJson(Map<String, dynamic> json) {
    return TransmissionModel(
      success: json['success'] as bool?,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    TransmissionModell.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class TransmissionModell {
  String? id;
  String? name;

  TransmissionModell({this.id, this.name});

  factory TransmissionModell.fromJson(Map<String, dynamic> json) {
    return TransmissionModell(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}
