abstract class CustomerVehicleCreateEvent {
  const CustomerVehicleCreateEvent();
}

class CreateCustomerVehicleRequested extends CustomerVehicleCreateEvent {
  final String customerId;
  final Map<String, dynamic> body;

  const CreateCustomerVehicleRequested({
    required this.customerId,
    required this.body,
  });
}
