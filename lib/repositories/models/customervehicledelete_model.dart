class CustomerVehicleDeleteModel {
  bool? success;
  String? message;
  CustomerVehicleDeleteData? data;

  CustomerVehicleDeleteModel({this.success, this.message, this.data});

  factory CustomerVehicleDeleteModel.fromJson(Map<String, dynamic> json) {
    return CustomerVehicleDeleteModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? CustomerVehicleDeleteData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class CustomerVehicleDeleteData {
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
  int? odometer;
  bool? spareTyre;
  bool? isDeleted;
  List<CustomerVehicleImage>? vehicleImages;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? color;
  String? countrySpec;
  int? numberOfKeys;

  CustomerVehicleDeleteData({
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
    this.odometer,
    this.spareTyre,
    this.isDeleted,
    this.vehicleImages,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.color,
    this.countrySpec,
    this.numberOfKeys,
  });

  factory CustomerVehicleDeleteData.fromJson(Map<String, dynamic> json) {
    return CustomerVehicleDeleteData(
      id: json['_id'],
      customerId: json['customer_id'],
      brandId: json['brand_id'],
      modelId: json['model_id'],
      variantId: json['variant_id'],
      year: json['year'],
      vin: json['vin'],
      plateNumber: json['plate_number'],
      engineNumber: json['engine_number'],
      fuelTypeId: json['fuel_type_id'],
      transmissionId: json['transmission_id'],
      odometer: json['odometer'],
      spareTyre: json['spare_tyre'],
      isDeleted: json['isDeleted'],
      vehicleImages: json['vehicle_images'] != null
          ? (json['vehicle_images'] as List)
                .map((e) => CustomerVehicleImage.fromJson(e))
                .toList()
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      v: json['__v'],
      color: json['color'],
      countrySpec: json['country_spec'],
      numberOfKeys: json['number_of_keys'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'customer_id': customerId,
      'brand_id': brandId,
      'model_id': modelId,
      'variant_id': variantId,
      'year': year,
      'vin': vin,
      'plate_number': plateNumber,
      'engine_number': engineNumber,
      'fuel_type_id': fuelTypeId,
      'transmission_id': transmissionId,
      'odometer': odometer,
      'spare_tyre': spareTyre,
      'isDeleted': isDeleted,
      'vehicle_images': vehicleImages?.map((e) => e.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      '__v': v,
      'color': color,
      'country_spec': countrySpec,
      'number_of_keys': numberOfKeys,
    };
  }
}

class CustomerVehicleImage {
  String? url;
  String? id;

  CustomerVehicleImage({this.url, this.id});

  factory CustomerVehicleImage.fromJson(Map<String, dynamic> json) {
    return CustomerVehicleImage(url: json['url'], id: json['_id']);
  }

  Map<String, dynamic> toJson() {
    return {'url': url, '_id': id};
  }
}
