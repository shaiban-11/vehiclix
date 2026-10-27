import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rootysysproject/bloc/updatecustomer/bloc/updatecustomer_event.dart';
import 'package:rootysysproject/bloc/updatecustomer/bloc/updatecustomer_state.dart';
import 'package:rootysysproject/repositories/Api/updatecustomer_api.dart';

class CustomerUpdateBloc
    extends Bloc<CustomerUpdateEvent, CustomerUpdateState> {
  final CustomerUpdateRepository repository;

  CustomerUpdateBloc({required this.repository})
    : super(CustomerUpdateInitial()) {
    on<CustomerUpdateRequested>(_onCustomerUpdateRequested);
  }

  Future<void> _onCustomerUpdateRequested(
    CustomerUpdateRequested event,
    Emitter<CustomerUpdateState> emit,
  ) async {
    emit(CustomerUpdateLoading());

    try {
      final response = await repository.updateCustomer(
        customerId: event.customerId,
        customerData: event.customerData,
      );

      if (response.success == true) {
        emit(CustomerUpdateSuccess(response));
      } else {
        emit(
          CustomerUpdateFailure(
            response.message ?? 'Failed to update customer',
          ),
        );
      }
    } catch (e) {
      emit(CustomerUpdateFailure(e.toString()));
    }
  }
}
