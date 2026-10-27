import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rootysysproject/bloc/submitinspection/bloc/submitinspection_event.dart';
import 'package:rootysysproject/bloc/submitinspection/bloc/submitinspection_state.dart';
import 'package:rootysysproject/repositories/Api/submitinspection_api.dart';

class InspectionSubmitBloc
    extends Bloc<InspectionSubmitEvent, InspectionSubmitState> {
  final InspectionSubmitRepo repository;

  InspectionSubmitBloc({required this.repository})
    : super(InspectionSubmitInitial()) {
    on<SubmitInspectionEvent>(_onSubmitInspection);
  }

  Future<void> _onSubmitInspection(
    SubmitInspectionEvent event,
    Emitter<InspectionSubmitState> emit,
  ) async {
    emit(InspectionSubmitLoading());

    try {
      final response = await repository.submitInspection(event.inspection);

      // Handle an API response that explicitly indicates failure.
      if (response is Map && response['success'] == false) {
        emit(
          InspectionSubmitFailure(
            response['message']?.toString() ?? 'Inspection submission failed.',
          ),
        );
        return;
      }

      emit(InspectionSubmitSuccess(response));
    } catch (e) {
      emit(InspectionSubmitFailure(e.toString()));
    }
  }
}
