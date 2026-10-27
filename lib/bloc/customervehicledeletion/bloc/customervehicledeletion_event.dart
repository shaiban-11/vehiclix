import 'package:equatable/equatable.dart';

abstract class CustomerVehicleDeleteEvent extends Equatable {
  const CustomerVehicleDeleteEvent();

  @override
  List<Object?> get props => [];
}

class DeleteCustomerVehicleRequested extends CustomerVehicleDeleteEvent {
  final String customerId;
  final String vehicleId;

  const DeleteCustomerVehicleRequested({
    required this.customerId,
    required this.vehicleId,
  });

  @override
  List<Object?> get props => [customerId, vehicleId];
}
