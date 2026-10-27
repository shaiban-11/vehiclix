import 'package:rootysysproject/repositories/models/submitinspection_model.dart';

abstract class InspectionSubmitEvent {}

class SubmitInspectionEvent extends InspectionSubmitEvent {
  final InspectionSubmitModel inspection;

  SubmitInspectionEvent({required this.inspection});
}
