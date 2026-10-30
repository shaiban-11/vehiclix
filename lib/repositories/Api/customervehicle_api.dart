import 'package:flutter/foundation.dart';
import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/models/customer_vehicle_model.dart';

class CustomerVehicleRepo {
  final ApiClient apiClient;

  CustomerVehicleRepo(this.apiClient);

  Future<CustomerVehicleModel> getCustomerVehicles(String customerId) async {
    final response = await apiClient.getCustomerVehicles(customerId);

    // Check the complete API response
    debugPrint('CUSTOMER VEHICLES API RESPONSE: $response');

    if (response is! Map<String, dynamic>) {
      throw Exception('Invalid customer vehicle response');
    }

    // Check the images in the returned response
    final data = response['data'];
    debugPrint('CUSTOMER VEHICLES DATA: $data');

    return CustomerVehicleModel.fromJson(response);
  }
}
