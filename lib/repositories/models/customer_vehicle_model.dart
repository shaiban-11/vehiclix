class CustomerVehicleModel {
  final bool success;
  final List<dynamic> data;

  CustomerVehicleModel({required this.success, required this.data});

  factory CustomerVehicleModel.fromJson(Map<String, dynamic> json) {
    return CustomerVehicleModel(
      success: json['success'] ?? false,
      data: json['data'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data};
  }
}
