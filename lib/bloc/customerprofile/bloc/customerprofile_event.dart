abstract class CustomerProfileEvent {
  const CustomerProfileEvent();
}

class FetchCustomerProfile extends CustomerProfileEvent {
  final String customerId;

  const FetchCustomerProfile(this.customerId);
}
