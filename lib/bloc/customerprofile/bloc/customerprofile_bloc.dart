import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/repositories/Api/customerprofile_api.dart';

import 'customerprofile_event.dart';
import 'customerprofile_state.dart';

class CustomerProfileBloc
    extends Bloc<CustomerProfileEvent, CustomerProfileState> {
  final CustomerProfileRepo repository;

  CustomerProfileBloc(this.repository) : super(const CustomerProfileState()) {
    on<FetchCustomerProfile>(_onFetchCustomerProfile);
  }

  Future<void> _onFetchCustomerProfile(
    FetchCustomerProfile event,
    Emitter<CustomerProfileState> emit,
  ) async {
    emit(
      state.copyWith(status: CustomerProfileStatus.loading, errorMessage: ''),
    );

    try {
      final result = await repository.getCustomerProfile(event.customerId);

      if (result.success == true && result.data != null) {
        emit(
          state.copyWith(
            status: CustomerProfileStatus.success,
            customerProfile: result,
            errorMessage: '',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: CustomerProfileStatus.failure,
            errorMessage: result.message ?? 'Failed to fetch customer profile',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CustomerProfileStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
