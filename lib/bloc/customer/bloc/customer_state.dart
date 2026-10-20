import 'package:equatable/equatable.dart';

import 'package:rootysysproject/repositories/models/customer_model.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object?> get props => [];
}

class CustomerInitial extends CustomerState {
  const CustomerInitial();
}

class CustomerLoading extends CustomerState {
  const CustomerLoading();
}

class CustomerSuccess extends CustomerState {
  final CustomerModel customerResponse;

  const CustomerSuccess(this.customerResponse);

  @override
  List<Object?> get props => [customerResponse];
}

class CustomerFailure extends CustomerState {
  final String message;

  const CustomerFailure(this.message);

  @override
  List<Object?> get props => [message];
}
