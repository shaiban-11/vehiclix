import 'package:flutter/foundation.dart';

@immutable
abstract class UpdateVehicleInfoEvent {}

class UpdateVehicleInfoRequested extends UpdateVehicleInfoEvent {
  final String customerId;
  final String vehicleId;
  final Map<String, dynamic> vehicleData;

  UpdateVehicleInfoRequested({
    required this.customerId,
    required this.vehicleId,
    required this.vehicleData,
  });
}
