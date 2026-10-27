import 'package:rootysysproject/repositories/models/inspectiondetails_model.dart';

abstract class VehicleInspectionState {}

class VehicleInspectionInitial extends VehicleInspectionState {}

class VehicleInspectionLoading extends VehicleInspectionState {}

class VehicleInspectionSuccess extends VehicleInspectionState {
  final VehicleInspectionModel inspection;

  VehicleInspectionSuccess({required this.inspection});
}

class VehicleInspectionFailure extends VehicleInspectionState {
  final String message;

  VehicleInspectionFailure({required this.message});
}
