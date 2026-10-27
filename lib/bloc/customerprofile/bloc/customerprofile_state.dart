import 'package:equatable/equatable.dart';
import 'package:rootysysproject/repositories/models/customerprofile_model.dart';

enum CustomerProfileStatus { initial, loading, success, failure }

class CustomerProfileState extends Equatable {
  final CustomerProfileStatus status;
  final CustomerProfileModel? customerProfile;
  final String errorMessage;

  const CustomerProfileState({
    this.status = CustomerProfileStatus.initial,
    this.customerProfile,
    this.errorMessage = '',
  });

  CustomerProfileState copyWith({
    CustomerProfileStatus? status,
    CustomerProfileModel? customerProfile,
    String? errorMessage,
  }) {
    return CustomerProfileState(
      status: status ?? this.status,
      customerProfile: customerProfile ?? this.customerProfile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, customerProfile, errorMessage];
}
