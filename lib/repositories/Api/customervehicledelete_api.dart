import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/repositories/models/customervehicledelete_model.dart';

class CustomerVehicleDeleteRepository {
  final ApiClient apiClient;

  CustomerVehicleDeleteRepository({required this.apiClient});

  Future<CustomerVehicleDeleteModel> deleteCustomerVehicle({
    required String customerId,
    required String vehicleId,
  }) async {
    final response = await apiClient.deleteCustomerVehicle(
      customerId: customerId,
      vehicleId: vehicleId,
    );

    if (response is Map<String, dynamic>) {
      return CustomerVehicleDeleteModel.fromJson(response);
    }

    if (response is Map) {
      return CustomerVehicleDeleteModel.fromJson(
        Map<String, dynamic>.from(response),
      );
    }

    throw Exception('Invalid response format while deleting customer vehicle');
  }
}
