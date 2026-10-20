import 'package:rootysysproject/repositories/models/Vehicle_model.dart';

abstract class VehicleModelState {}

class VehicleModelInitial extends VehicleModelState {}

class VehicleModelLoading extends VehicleModelState {}

class VehicleModelSuccess extends VehicleModelState {
  final VehicleModel vehicleModelResponse;

  VehicleModelSuccess(this.vehicleModelResponse);
}

class VehicleModelFailure extends VehicleModelState {
  final String message;

  VehicleModelFailure(this.message);
}
