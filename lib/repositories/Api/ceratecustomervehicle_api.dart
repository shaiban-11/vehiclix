import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/models/createcustomervehicle_model.dart';

class CustomerVehicleCreateRepository {
  final ApiClient apiClient;

  CustomerVehicleCreateRepository({required this.apiClient});

  Future<CustomerVehicleCreateModel> createCustomerVehicle({
    required String customerId,
    required Map<String, dynamic> body,
  }) async {
    final response = await apiClient.createCustomerVehicle(
      customerId: customerId,
      body: body,
    );

    if (response is! Map) {
      throw Exception('Invalid customer vehicle response');
    }

    final result = CustomerVehicleCreateModel.fromJson(
      Map<String, dynamic>.from(response),
    );

    if (result.success != true) {
      throw Exception(result.message ?? 'Failed to create customer vehicle');
    }

    return result;
  }
}
