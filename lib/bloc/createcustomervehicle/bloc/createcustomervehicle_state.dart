import 'package:rootysysproject/repositories/models/createcustomervehicle_model.dart';

enum CustomerVehicleCreateStatus { initial, loading, success, failure }

class CustomerVehicleCreateState {
  final CustomerVehicleCreateStatus status;
  final CustomerVehicleCreateModel? response;
  final String? errorMessage;

  const CustomerVehicleCreateState({
    this.status = CustomerVehicleCreateStatus.initial,
    this.response,
    this.errorMessage,
  });
}
