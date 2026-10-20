import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/bloc/customer/bloc/customer_event.dart';
import 'package:rootysysproject/bloc/customer/bloc/customer_state.dart';

import 'package:rootysysproject/repositories/Api/cutomer_api.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;

  CustomerBloc({required this.customerRepository})
    : super(const CustomerInitial()) {
    on<CustomerFetchRequested>(_onFetchCustomers);
  }

  Future<void> _onFetchCustomers(
    CustomerFetchRequested event,
    Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerLoading());

    try {
      final response = await customerRepository.fetchCustomers(
        page: event.page,
        limit: event.limit,
      );

      if (response.success == false) {
        emit(const CustomerFailure('Failed to load customers'));
        return;
      }

      emit(CustomerSuccess(response));
    } catch (e) {
      emit(CustomerFailure(e.toString()));
    }
  }
}
