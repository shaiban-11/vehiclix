import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/repositories/Api/customervehicle_api.dart';

import 'customervehicle_event.dart';
import 'customervehicle_state.dart';

class CustomerVehicleBloc
    extends Bloc<CustomerVehicleEvent, CustomerVehicleState> {
  final CustomerVehicleRepo repository;

  CustomerVehicleBloc(this.repository) : super(const CustomerVehicleState()) {
    on<FetchCustomerVehicles>(_onFetchCustomerVehicles);
  }

  Future<void> _onFetchCustomerVehicles(
    FetchCustomerVehicles event,
    Emitter<CustomerVehicleState> emit,
  ) async {
    emit(state.copyWith(status: CustomerVehicleStatus.loading));

    try {
      final result = await repository.getCustomerVehicles(event.customerId);

      if (result.success) {
        emit(
          state.copyWith(
            status: CustomerVehicleStatus.success,
            customerVehicle: result,
            errorMessage: '',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: CustomerVehicleStatus.failure,
            errorMessage: 'Failed to fetch customer vehicles',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CustomerVehicleStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
