abstract class CustomerUpdateEvent {}

class CustomerUpdateRequested extends CustomerUpdateEvent {
  final String customerId;
  final Map<String, dynamic> customerData;

  CustomerUpdateRequested({
    required this.customerId,
    required this.customerData,
  });
}
