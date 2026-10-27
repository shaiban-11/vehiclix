import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rootysysproject/bloc/updateinspection/bloc/updateinspection_event.dart';
import 'package:rootysysproject/bloc/updateinspection/bloc/updateinspection_state.dart';
import 'package:rootysysproject/repositories/Api/updateinspection_api.dart';

class InspectionUpdateBloc
    extends Bloc<InspectionUpdateEvent, InspectionUpdateState> {
  final InspectionUpdateRepo repository;

  InspectionUpdateBloc({required this.repository})
    : super(InspectionUpdateInitial()) {
    on<InspectionUpdateRequested>(_onInspectionUpdateRequested);
  }

  Future<void> _onInspectionUpdateRequested(
    InspectionUpdateRequested event,
    Emitter<InspectionUpdateState> emit,
  ) async {
    emit(InspectionUpdateLoading());

    try {
      final response = await repository.updateInspection(
        inspectionId: event.inspectionId,
        inspectionData: event.inspectionData,
      );

      if (response.success == true) {
        emit(InspectionUpdateSuccess(response));
      } else {
        emit(
          InspectionUpdateFailure(
            response.message ?? 'Failed to update inspection',
          ),
        );
      }
    } catch (e) {
      emit(InspectionUpdateFailure(e.toString()));
    }
  }
}
