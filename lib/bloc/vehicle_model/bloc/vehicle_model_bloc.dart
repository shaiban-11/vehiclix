import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/repositories/Api/vehiclemodel_api.dart';

import 'vehicle_model_event.dart';
import 'vehicle_model_state.dart';

class VehicleModelBloc extends Bloc<VehicleModelEvent, VehicleModelState> {
  final VehicleModelRepository vehicleModelRepository;

  VehicleModelBloc({required this.vehicleModelRepository})
    : super(VehicleModelInitial()) {
    on<VehicleModelFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    VehicleModelFetchRequested event,
    Emitter<VehicleModelState> emit,
  ) async {
    emit(VehicleModelLoading());

    try {
      final response = await vehicleModelRepository.getVehicleModels();

      debugPrint('VEHICLE MODEL API SUCCESS: ${response.success}');
      debugPrint('VEHICLE MODEL API DATA: ${response.data}');

      if (response.success == true) {
        // Print each vehicle model's ID and name
        for (final model in response.data ?? []) {
          debugPrint('MODEL ID: ${model.id}, MODEL NAME: ${model.name}');
        }

        emit(VehicleModelSuccess(response));
      } else {
        emit(VehicleModelFailure('Failed to load vehicle models'));
      }
    } catch (e, stackTrace) {
      debugPrint('VEHICLE MODEL ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(VehicleModelFailure(e.toString()));
    }
  }
}
