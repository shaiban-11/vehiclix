import 'package:rootysysproject/repositories/models/completeinspection_model.dart';

abstract class CompletedInspectionState {}

class CompletedInspectionInitial extends CompletedInspectionState {}

class CompletedInspectionLoading extends CompletedInspectionState {}

class CompletedInspectionSuccess extends CompletedInspectionState {
  final CompletedInspectionModel response;

  CompletedInspectionSuccess(this.response);
}

class CompletedInspectionFailure extends CompletedInspectionState {
  final String message;

  CompletedInspectionFailure(this.message);
}
