abstract class VehicleInspectionEvent {}

class FetchVehicleInspection extends VehicleInspectionEvent {
  final String inspectionId;

  FetchVehicleInspection({required this.inspectionId});
}
