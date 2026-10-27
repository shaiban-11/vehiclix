import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/bloc/inspectiondetail/bloc/inspectiondetail_event.dart';
import 'package:rootysysproject/bloc/inspectiondetail/bloc/inspectiondetail_state.dart';

import 'package:rootysysproject/repositories/Api/inspectiondetails_api.dart';

class VehicleInspectionBloc
    extends Bloc<VehicleInspectionEvent, VehicleInspectionState> {
  final VehicleInspectionRepository repository;

  VehicleInspectionBloc({required this.repository})
    : super(VehicleInspectionInitial()) {
    on<FetchVehicleInspection>(_onFetchVehicleInspection);
  }

  Future<void> _onFetchVehicleInspection(
    FetchVehicleInspection event,
    Emitter<VehicleInspectionState> emit,
  ) async {
    emit(VehicleInspectionLoading());

    try {
      final result = await repository.getVehicleInspection(event.inspectionId);

      emit(VehicleInspectionSuccess(inspection: result));
    } catch (e) {
      emit(VehicleInspectionFailure(message: e.toString()));
    }
  }
}
