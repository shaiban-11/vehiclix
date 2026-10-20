import 'package:rootysysproject/repositories/models/Vehicle_verients.dart';

abstract class VehicleVarientsState {}

class VehicleVarientsInitial extends VehicleVarientsState {}

class VehicleVarientsLoading extends VehicleVarientsState {}

class VehicleVarientsSuccess extends VehicleVarientsState {
  final VehicleVarientsModel response;

  VehicleVarientsSuccess(this.response);
}

class VehicleVarientsFailure extends VehicleVarientsState {
  final String message;

  VehicleVarientsFailure(this.message);
}
