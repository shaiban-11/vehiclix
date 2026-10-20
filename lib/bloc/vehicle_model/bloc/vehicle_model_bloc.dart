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

      if (response.success == true) {
        emit(VehicleModelSuccess(response));
      } else {
        emit(VehicleModelFailure('Failed to load vehicle models'));
      }
    } catch (e) {
      emit(VehicleModelFailure(e.toString()));
    }
  }
}
