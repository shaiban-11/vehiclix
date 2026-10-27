import 'package:equatable/equatable.dart';

import 'package:rootysysproject/repositories/models/customervehicledelete_model.dart';

abstract class CustomerVehicleDeleteState extends Equatable {
  const CustomerVehicleDeleteState();

  @override
  List<Object?> get props => [];
}

class CustomerVehicleDeleteInitial extends CustomerVehicleDeleteState {
  const CustomerVehicleDeleteInitial();
}

class CustomerVehicleDeleteLoading extends CustomerVehicleDeleteState {
  const CustomerVehicleDeleteLoading();
}

class CustomerVehicleDeleteSuccess extends CustomerVehicleDeleteState {
  final CustomerVehicleDeleteModel response;

  const CustomerVehicleDeleteSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CustomerVehicleDeleteFailure extends CustomerVehicleDeleteState {
  final String message;

  const CustomerVehicleDeleteFailure(this.message);

  @override
  List<Object?> get props => [message];
}
