import 'package:rootysysproject/repositories/models/inspectioncategoryandfileds_model.dart';

abstract class InspectionDetailsState {}

class InspectionDetailsInitial extends InspectionDetailsState {}

class InspectionDetailsLoading extends InspectionDetailsState {}

class InspectionDetailsLoaded extends InspectionDetailsState {
  final InspectionDetailsModel model;

  InspectionDetailsLoaded(this.model);
}

class InspectionDetailsError extends InspectionDetailsState {
  final String message;

  InspectionDetailsError(this.message);
}
