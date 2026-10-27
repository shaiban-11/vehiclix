class CustomerVehicleCreateModel {
  bool? success;
  String? message;
  CreatedCustomerVehicleData? data;

  CustomerVehicleCreateModel({this.success, this.message, this.data});

  factory CustomerVehicleCreateModel.fromJson(Map<String, dynamic> json) {
    return CustomerVehicleCreateModel(
      success: json['success'] as bool?,
      message: json['message']?.toString(),
      data: json['data'] is Map
          ? CreatedCustomerVehicleData.fromJson(
              Map<String, dynamic>.from(json['data']),
            )
          : null,
    );
  }
}

class CreatedCustomerVehicleData {
  String? id;
  String? customerId;
  String? brandId;
  String? modelId;
  String? variantId;
  int? year;
  String? vin;
  String? plateNumber;
  String? engineNumber;
  String? fuelTypeId;
  String? transmissionId;
  String? color;
  int? odometer;
  bool? spareTyre;
  int? numberOfKeys;
  String? countrySpec;
  bool? isDeleted;
  List<CustomerVehicleImage> vehicleImages;
  String? createdAt;
  String? updatedAt;

  CreatedCustomerVehicleData({
    this.id,
    this.customerId,
    this.brandId,
    this.modelId,
    this.variantId,
    this.year,
    this.vin,
    this.plateNumber,
    this.engineNumber,
    this.fuelTypeId,
    this.transmissionId,
    this.color,
    this.odometer,
    this.spareTyre,
    this.numberOfKeys,
    this.countrySpec,
    this.isDeleted,
    this.vehicleImages = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory CreatedCustomerVehicleData.fromJson(Map<String, dynamic> json) {
    return CreatedCustomerVehicleData(
      id: json['_id']?.toString(),
      customerId: json['customer_id']?.toString(),
      brandId: json['brand_id']?.toString(),
      modelId: json['model_id']?.toString(),
      variantId: json['variant_id']?.toString(),
      year: _toInt(json['year']),
      vin: json['vin']?.toString(),
      plateNumber: json['plate_number']?.toString(),
      engineNumber: json['engine_number']?.toString(),
      fuelTypeId: json['fuel_type_id']?.toString(),
      transmissionId: json['transmission_id']?.toString(),
      color: json['color']?.toString(),
      odometer: _toInt(json['odometer']),
      spareTyre: json['spare_tyre'] as bool?,
      numberOfKeys: _toInt(json['number_of_keys']),
      countrySpec: json['country_spec']?.toString(),
      isDeleted: (json['isDeleted'] ?? json['is_deleted']) as bool?,
      vehicleImages:
          (json['vehicle_images'] as List?)
              ?.whereType<Map>()
              .map(
                (item) => CustomerVehicleImage.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList() ??
          [],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}

class CustomerVehicleImage {
  String? id;
  String? url;

  CustomerVehicleImage({this.id, this.url});

  factory CustomerVehicleImage.fromJson(Map<String, dynamic> json) {
    return CustomerVehicleImage(
      id: json['_id']?.toString(),
      url: json['url']?.toString(),
    );
  }
}
