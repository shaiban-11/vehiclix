import 'package:rootysysproject/repositories/models/updateinspection_model.dart';

abstract class InspectionUpdateState {}

class InspectionUpdateInitial extends InspectionUpdateState {}

class InspectionUpdateLoading extends InspectionUpdateState {}

class InspectionUpdateSuccess extends InspectionUpdateState {
  final InspectionUpdateModel inspectionResponse;

  InspectionUpdateSuccess(this.inspectionResponse);
}

class InspectionUpdateFailure extends InspectionUpdateState {
  final String message;

  InspectionUpdateFailure(this.message);
}
