class UpdateVehicleInfoModel {
  bool? success;
  String? message;
  UpdateVehicleInfoData? data;

  UpdateVehicleInfoModel({this.success, this.message, this.data});

  factory UpdateVehicleInfoModel.fromJson(Map<String, dynamic> json) {
    return UpdateVehicleInfoModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? UpdateVehicleInfoData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class UpdateVehicleInfoData {
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
  List<VehicleImage>? vehicleImages;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? color;
  int? numberOfKeys;
  String? countrySpec;

  UpdateVehicleInfoData({
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
    this.numberOfKeys,
    this.countrySpec,
  });

  factory UpdateVehicleInfoData.fromJson(Map<String, dynamic> json) {
    return UpdateVehicleInfoData(
      id: json['_id']?.toString(),
      customerId: json['customer_id']?.toString(),
      brandId: json['brand_id']?.toString(),
      modelId: json['model_id']?.toString(),
      variantId: json['variant_id']?.toString(),
      year: (json['year'] as num?)?.toInt(),
      vin: json['vin'],
      plateNumber: json['plate_number'],
      engineNumber: json['engine_number'],
      fuelTypeId: json['fuel_type_id']?.toString(),
      transmissionId: json['transmission_id']?.toString(),
      odometer: (json['odometer'] as num?)?.toInt(),
      spareTyre: json['spare_tyre'],
      isDeleted: json['isDeleted'],
      vehicleImages: json['vehicle_images'] != null
          ? (json['vehicle_images'] as List)
                .map((e) => VehicleImage.fromJson(e))
                .toList()
          : [],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      v: (json['__v'] as num?)?.toInt(),
      color: json['color'],
      numberOfKeys: (json['number_of_keys'] as num?)?.toInt(),
      countrySpec: json['country_spec']?.toString(),
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
      'created_at': createdAt,
      'updated_at': updatedAt,
      '__v': v,
      'color': color,
      'number_of_keys': numberOfKeys,
      'country_spec': countrySpec,
    };
  }
}

class VehicleImage {
  String? url;
  String? id;

  VehicleImage({this.url, this.id});

  factory VehicleImage.fromJson(Map<String, dynamic> json) {
    return VehicleImage(url: json['url'], id: json['_id']?.toString());
  }

  Map<String, dynamic> toJson() {
    return {'url': url, '_id': id};
  }
}
