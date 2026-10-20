import 'package:rootysysproject/repositories/models/Fuel_model.dart';

abstract class FuelTypeState {}

class FuelTypeInitial extends FuelTypeState {}

class FuelTypeLoading extends FuelTypeState {}

class FuelTypeSuccess extends FuelTypeState {
  final FuelTypesResponse fuelTypesResponse;

  FuelTypeSuccess(this.fuelTypesResponse);
}

class FuelTypeFailure extends FuelTypeState {
  final String message;

  FuelTypeFailure(this.message);
}
