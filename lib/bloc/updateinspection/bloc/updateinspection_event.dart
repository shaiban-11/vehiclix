import 'package:flutter_bloc/flutter_bloc.dart';

abstract class InspectionUpdateEvent {}

class InspectionUpdateRequested extends InspectionUpdateEvent {
  final String inspectionId;
  final Map<String, dynamic> inspectionData;

  InspectionUpdateRequested({
    required this.inspectionId,
    required this.inspectionData,
  });
}
