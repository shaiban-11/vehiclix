import 'package:rootysysproject/repositories/models/draftinsepction_model.dart';

abstract class DraftInspectionState {}

class DraftInspectionInitial extends DraftInspectionState {}

class DraftInspectionLoading extends DraftInspectionState {}

class DraftInspectionSuccess extends DraftInspectionState {
  final DraftInspectionModel response;

  DraftInspectionSuccess({required this.response});
}

class DraftInspectionFailure extends DraftInspectionState {
  final String message;

  DraftInspectionFailure({required this.message});
}
