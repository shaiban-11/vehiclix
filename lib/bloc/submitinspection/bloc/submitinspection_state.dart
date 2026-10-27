abstract class InspectionSubmitState {}

class InspectionSubmitInitial extends InspectionSubmitState {}

class InspectionSubmitLoading extends InspectionSubmitState {}

class InspectionSubmitSuccess extends InspectionSubmitState {
  final dynamic response;

  InspectionSubmitSuccess(this.response);
}

class InspectionSubmitFailure extends InspectionSubmitState {
  final String message;

  InspectionSubmitFailure(this.message);
}
