import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/repositories/models/customerprofile_model.dart';

class CustomerProfileRepo {
  final ApiClient apiClient;

  CustomerProfileRepo(this.apiClient);

  Future<CustomerProfileModel> getCustomerProfile(String customerId) async {
    final response = await apiClient.getCustomerProfile(customerId);

    if (response is! Map) {
      throw Exception('Invalid customer profile response');
    }

    return CustomerProfileModel.fromJson(Map<String, dynamic>.from(response));
  }
}
