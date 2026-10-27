abstract class DraftInspectionEvent {}

class FetchDraftInspections extends DraftInspectionEvent {
  final int page;
  final int limit;

  FetchDraftInspections({this.page = 1, this.limit = 10});
}
