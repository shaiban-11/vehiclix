import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/bloc/customervehicledeletion/bloc/customervehicledeletion_event.dart';
import 'package:rootysysproject/bloc/customervehicledeletion/bloc/customervehicledeletion_state.dart';
import 'package:rootysysproject/repositories/Api/customervehicledelete_api.dart';

import 'package:rootysysproject/repositories/Api/api_client.dart';

class CustomerVehicleDeleteBloc
    extends Bloc<CustomerVehicleDeleteEvent, CustomerVehicleDeleteState> {
  final CustomerVehicleDeleteRepository repository;

  CustomerVehicleDeleteBloc({required this.repository})
    : super(const CustomerVehicleDeleteInitial()) {
    on<DeleteCustomerVehicleRequested>(_onDeleteCustomerVehicle);
  }

  Future<void> _onDeleteCustomerVehicle(
    DeleteCustomerVehicleRequested event,
    Emitter<CustomerVehicleDeleteState> emit,
  ) async {
    emit(const CustomerVehicleDeleteLoading());

    try {
      final response = await repository.deleteCustomerVehicle(
        customerId: event.customerId,
        vehicleId: event.vehicleId,
      );

      if (response.success == true) {
        emit(CustomerVehicleDeleteSuccess(response));
      } else {
        emit(
          CustomerVehicleDeleteFailure(
            response.message ?? 'Failed to delete customer vehicle',
          ),
        );
      }
    } on ApiException catch (e) {
      emit(CustomerVehicleDeleteFailure(e.message));
    } catch (e) {
      emit(
        CustomerVehicleDeleteFailure('Failed to delete customer vehicle: $e'),
      );
    }
  }
}
