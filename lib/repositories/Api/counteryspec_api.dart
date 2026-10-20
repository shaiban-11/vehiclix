import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/repositories/models/countryspec_model.dart';

class CountrySpecRepository {
  final ApiClient apiClient;

  CountrySpecRepository({required this.apiClient});

  Future<CountrySpecModel> fetchCountrySpecs() async {
    try {
      final response = await apiClient.getCountrySpecifications();

      if (response is Map) {
        return CountrySpecModel.fromJson(Map<String, dynamic>.from(response));
      }

      throw Exception('Invalid country specifications API response');
    } catch (e) {
      throw Exception('Failed to fetch country specifications: $e');
    }
  }
}
