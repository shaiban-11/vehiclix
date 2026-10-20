import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/repositories/models/customer_model.dart';

class CustomerRepository {
  final ApiClient apiClient;

  CustomerRepository({required this.apiClient});

  Future<CustomerModel> fetchCustomers({int page = 1, int limit = 10}) async {
    try {
      final response = await apiClient.getCustomers(page: page, limit: limit);

      if (response is Map) {
        return CustomerModel.fromJson(Map<String, dynamic>.from(response));
      }

      throw Exception('Invalid customers API response');
    } catch (e) {
      throw Exception('Failed to fetch customers: $e');
    }
  }
}
