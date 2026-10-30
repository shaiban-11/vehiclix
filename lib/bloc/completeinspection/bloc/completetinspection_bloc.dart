import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rootysysproject/bloc/completeinspection/bloc/completetinspection_event.dart';
import 'package:rootysysproject/bloc/completeinspection/bloc/completetinspection_state.dart';
import 'package:rootysysproject/repositories/Api/complete_inspection_api.dart';

class CompletedInspectionBloc
    extends Bloc<CompletedInspectionEvent, CompletedInspectionState> {
  final CompletedInspectionRepository repository;

  CompletedInspectionBloc({required this.repository})
    : super(CompletedInspectionInitial()) {
    // Fetch completed inspections list
    on<FetchCompletedInspections>(_onFetchCompletedInspections);

    // Complete a particular inspection
    on<CompletedInspectionRequested>(_onCompleteInspection);
  }

  // --------------------------------------------------
  // FETCH COMPLETED INSPECTIONS
  // --------------------------------------------------

  Future<void> _onFetchCompletedInspections(
    FetchCompletedInspections event,
    Emitter<CompletedInspectionState> emit,
  ) async {
    emit(CompletedInspectionLoading());

    try {
      final response = await repository.fetchCompletedInspections(
        page: event.page,
        limit: event.limit,
      );

      if (response.success != true) {
        emit(
          CompletedInspectionFailure(
            response.message ?? 'Something went wrong',
          ),
        );
        return;
      }

      emit(CompletedInspectionSuccess(response));
    } catch (e) {
      emit(CompletedInspectionFailure(e.toString()));
    }
  }

  Future<void> _onCompleteInspection(
    CompletedInspectionRequested event,
    Emitter<CompletedInspectionState> emit,
  ) async {
    emit(CompletedInspectionLoading());

    try {
      final response = await repository.completeInspection(event.inspectionId);
      if (response.success != true) {
        emit(
          CompletedInspectionFailure(
            response.message ?? 'Something went wrong',
          ),
        );
        return;
      }

      emit(CompletedInspectionSuccess(response));
    } catch (e) {
      emit(CompletedInspectionFailure(e.toString()));
    }
  }
}
