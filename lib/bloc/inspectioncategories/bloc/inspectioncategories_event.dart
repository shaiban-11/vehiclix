abstract class InspectionDetailsEvent {}

class GetInspectionDataFieldsEvent extends InspectionDetailsEvent {
  final String vehicleId;
  final String typeItemId;

  GetInspectionDataFieldsEvent({
    required this.vehicleId,
    required this.typeItemId,
  });
}
