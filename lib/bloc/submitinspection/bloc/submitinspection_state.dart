abstract class InspectionSubmitState {}

class InspectionSubmitInitial extends InspectionSubmitState {}

class InspectionSubmitLoading extends InspectionSubmitState {}

class InspectionSubmitSuccess extends InspectionSubmitState {
  final dynamic response;
  final String inspectionId;

  InspectionSubmitSuccess({required this.response, required this.inspectionId});
}

class InspectionSubmitFailure extends InspectionSubmitState {
  final String message;

  InspectionSubmitFailure(this.message);
}
