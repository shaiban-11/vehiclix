abstract class CustomerVehicleEvent {
  const CustomerVehicleEvent();
}

class FetchCustomerVehicles extends CustomerVehicleEvent {
  final String customerId;

  const FetchCustomerVehicles(this.customerId);
}
