import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rootysysproject/bloc/draftinspection/bloc/draft_inspection_event.dart';
import 'package:rootysysproject/bloc/draftinspection/bloc/draft_inspection_state.dart';
import 'package:rootysysproject/repositories/Api/draftinpsection_api.dart';

class DraftInspectionBloc
    extends Bloc<DraftInspectionEvent, DraftInspectionState> {
  final DraftInspectionRepository repository;

  DraftInspectionBloc({required this.repository})
    : super(DraftInspectionInitial()) {
    on<FetchDraftInspections>(_onFetchDraftInspections);
  }

  Future<void> _onFetchDraftInspections(
    FetchDraftInspections event,
    Emitter<DraftInspectionState> emit,
  ) async {
    emit(DraftInspectionLoading());

    try {
      final result = await repository.getDraftInspections(
        page: event.page,
        limit: event.limit,
      );

      emit(DraftInspectionSuccess(response: result));
    } catch (e) {
      emit(DraftInspectionFailure(message: e.toString()));
    }
  }
}
