import 'package:flutter/foundation.dart';
import 'package:rootysysproject/repositories/models/updatevehicleinfo_model.dart';

@immutable
abstract class UpdateVehicleInfoState {}

class UpdateVehicleInfoInitial extends UpdateVehicleInfoState {}

class UpdateVehicleInfoLoading extends UpdateVehicleInfoState {}

class UpdateVehicleInfoSuccess extends UpdateVehicleInfoState {
  final UpdateVehicleInfoModel response;

  UpdateVehicleInfoSuccess({required this.response});
}

class UpdateVehicleInfoFailure extends UpdateVehicleInfoState {
  final String message;

  UpdateVehicleInfoFailure({required this.message});
}
