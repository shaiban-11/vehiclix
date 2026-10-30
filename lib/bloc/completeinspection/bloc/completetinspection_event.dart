abstract class CompletedInspectionEvent {}

class FetchCompletedInspections extends CompletedInspectionEvent {
  final int page;
  final int limit;

  FetchCompletedInspections({this.page = 1, this.limit = 10});
}

class CompletedInspectionRequested extends CompletedInspectionEvent {
  final String inspectionId;

  CompletedInspectionRequested({required this.inspectionId});
}
