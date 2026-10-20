import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/repositories/Api/vehiclevarients_api.dart';

import 'vehicle_varients_event.dart';
import 'vehicle_varients_state.dart';

class VehicleVarientsBloc
    extends Bloc<VehicleVarientsEvent, VehicleVarientsState> {
  final VehicleVarientsRepository repository;

  VehicleVarientsBloc({required this.repository})
    : super(VehicleVarientsInitial()) {
    on<VehicleVarientsFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    VehicleVarientsFetchRequested event,
    Emitter<VehicleVarientsState> emit,
  ) async {
    emit(VehicleVarientsLoading());

    try {
      final response = await repository.fetchVehicleVarients(
        page: event.page,
        limit: event.limit,
        search: event.search,
      );

      if (response.success == false) {
        emit(VehicleVarientsFailure('Failed to load vehicle variants'));
        return;
      }

      emit(VehicleVarientsSuccess(response));
    } catch (e) {
      emit(VehicleVarientsFailure(e.toString()));
    }
  }
}
