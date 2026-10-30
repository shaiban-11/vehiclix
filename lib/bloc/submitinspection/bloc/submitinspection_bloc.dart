import 'package:flutter/material.dart';
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

      debugPrint('SUBMIT INSPECTION RESPONSE: $response');

      if (response is! Map) {
        emit(InspectionSubmitFailure('Invalid API response.'));
        return;
      }

      if (response['success'] != true) {
        emit(
          InspectionSubmitFailure(
            response['message']?.toString() ?? 'Inspection submission failed.',
          ),
        );
        return;
      }

      // Extract inspection ID from data._id
      final data = response['data'];

      final inspectionId = data is Map
          ? (data['_id'] ?? data['id'] ?? '').toString()
          : '';

      debugPrint('SUBMIT SUCCESS INSPECTION ID: $inspectionId');

      if (inspectionId.isEmpty) {
        emit(
          InspectionSubmitFailure(
            'Inspection saved, but inspection ID was not returned.',
          ),
        );
        return;
      }

      emit(
        InspectionSubmitSuccess(response: response, inspectionId: inspectionId),
      );
    } catch (e) {
      emit(InspectionSubmitFailure(e.toString()));
    }
  }
}
