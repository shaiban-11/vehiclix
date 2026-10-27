import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/repositories/models/updatecustomer_model.dart';

class CustomerUpdateRepository {
  final ApiClient apiClient;

  CustomerUpdateRepository({required this.apiClient});

  Future<CustomerUpdateModel> updateCustomer({
    required String customerId,
    required Map<String, dynamic> customerData,
  }) async {
    final response = await apiClient.updateCustomer(
      customerId: customerId,
      customerData: customerData,
    );

    if (response is! Map) {
      throw Exception('Invalid customer update response');
    }

    return CustomerUpdateModel.fromJson(Map<String, dynamic>.from(response));
  }
}
