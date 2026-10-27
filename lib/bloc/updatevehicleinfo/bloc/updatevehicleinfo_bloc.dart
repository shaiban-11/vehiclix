import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rootysysproject/bloc/updatevehicleinfo/bloc/updatevehicleinfo_event.dart';
import 'package:rootysysproject/bloc/updatevehicleinfo/bloc/updatevehicleinfo_state.dart';
import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/Api/updatevehicleinfo_api.dart';

class UpdateVehicleInfoBloc
    extends Bloc<UpdateVehicleInfoEvent, UpdateVehicleInfoState> {
  final UpdateVehicleInfoRepository repository;

  UpdateVehicleInfoBloc({
    required this.repository,
    required ApiClient apiClient,
  }) : super(UpdateVehicleInfoInitial()) {
    on<UpdateVehicleInfoRequested>(_onUpdateVehicleInfo);
  }

  Future<void> _onUpdateVehicleInfo(
    UpdateVehicleInfoRequested event,
    Emitter<UpdateVehicleInfoState> emit,
  ) async {
    emit(UpdateVehicleInfoLoading());

    try {
      final response = await repository.updateVehicleInfo(
        customerId: event.customerId,
        vehicleId: event.vehicleId,
        vehicleData: event.vehicleData,
      );

      if (response.success == true) {
        emit(UpdateVehicleInfoSuccess(response: response));
      } else {
        emit(
          UpdateVehicleInfoFailure(
            message: response.message ?? 'Failed to update vehicle information',
          ),
        );
      }
    } catch (e) {
      emit(UpdateVehicleInfoFailure(message: e.toString()));
    }
  }
}
