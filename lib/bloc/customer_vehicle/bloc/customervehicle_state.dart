import 'package:rootysysproject/repositories/models/customer_vehicle_model.dart';

enum CustomerVehicleStatus { initial, loading, success, failure }

class CustomerVehicleState {
  final CustomerVehicleStatus status;
  final CustomerVehicleModel? customerVehicle;
  final String? errorMessage;

  const CustomerVehicleState({
    this.status = CustomerVehicleStatus.initial,
    this.customerVehicle,
    this.errorMessage,
  });

  CustomerVehicleState copyWith({
    CustomerVehicleStatus? status,
    CustomerVehicleModel? customerVehicle,
    String? errorMessage,
  }) {
    return CustomerVehicleState(
      status: status ?? this.status,
      customerVehicle: customerVehicle ?? this.customerVehicle,
      errorMessage: errorMessage,
    );
  }
}
