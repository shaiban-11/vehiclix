import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/bloc/Fuel/bloc/fueltype_event.dart';
import 'package:rootysysproject/bloc/Fuel/bloc/fueltype_state.dart';
import 'package:rootysysproject/repositories/Api/fuel_api.dart';

class FuelTypeBloc extends Bloc<FuelTypeEvent, FuelTypeState> {
  final FuelTypeRepository fuelTypeRepository;

  FuelTypeBloc({required this.fuelTypeRepository}) : super(FuelTypeInitial()) {
    on<FuelTypesFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    FuelTypesFetchRequested event,
    Emitter<FuelTypeState> emit,
  ) async {
    emit(FuelTypeLoading());

    try {
      final response = await fuelTypeRepository.getFuelTypes();

      if (response.success == true) {
        emit(FuelTypeSuccess(response));
      } else {
        emit(FuelTypeFailure('Failed to load fuel types'));
      }
    } catch (e) {
      emit(FuelTypeFailure(e.toString()));
    }
  }
}
