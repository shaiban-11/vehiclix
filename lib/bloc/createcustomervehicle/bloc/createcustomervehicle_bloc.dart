import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/bloc/createcustomervehicle/bloc/createcustomervehicle_event.dart';
import 'package:rootysysproject/bloc/createcustomervehicle/bloc/createcustomervehicle_state.dart';

import 'package:rootysysproject/repositories/Api/ceratecustomervehicle_api.dart';

class CustomerVehicleCreateBloc
    extends Bloc<CustomerVehicleCreateEvent, CustomerVehicleCreateState> {
  final CustomerVehicleCreateRepository repository;

  CustomerVehicleCreateBloc({required this.repository})
    : super(const CustomerVehicleCreateState()) {
    on<CreateCustomerVehicleRequested>(_onCreateCustomerVehicle);
  }

  Future<void> _onCreateCustomerVehicle(
    CreateCustomerVehicleRequested event,
    Emitter<CustomerVehicleCreateState> emit,
  ) async {
    emit(
      const CustomerVehicleCreateState(
        status: CustomerVehicleCreateStatus.loading,
      ),
    );

    try {
      final response = await repository.createCustomerVehicle(
        customerId: event.customerId,
        body: event.body,
      );

      emit(
        CustomerVehicleCreateState(
          status: CustomerVehicleCreateStatus.success,
          response: response,
        ),
      );
    } catch (e) {
      emit(
        CustomerVehicleCreateState(
          status: CustomerVehicleCreateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
