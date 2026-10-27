import 'package:rootysysproject/repositories/models/inspectiontype_model.dart';

abstract class InspectionState {}

class InspectionInitial extends InspectionState {}

class InspectionLoading extends InspectionState {}

class InspectionTypesLoaded extends InspectionState {
  final InspectionModel inspectionModel;

  InspectionTypesLoaded(this.inspectionModel);
}

class InspectionError extends InspectionState {
  final String message;

  InspectionError(this.message);
}
