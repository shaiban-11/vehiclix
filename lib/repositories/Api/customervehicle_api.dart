import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/models/customer_vehicle_model.dart';

class CustomerVehicleRepo {
  final ApiClient apiClient;

  CustomerVehicleRepo(this.apiClient);

  Future<CustomerVehicleModel> getCustomerVehicles(String customerId) async {
    final response = await apiClient.getCustomerVehicles(customerId);

    if (response is! Map<String, dynamic>) {
      throw Exception('Invalid customer vehicle response');
    }

    return CustomerVehicleModel.fromJson(response);
  }
}
