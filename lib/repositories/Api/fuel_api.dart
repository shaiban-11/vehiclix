import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/models/Fuel_model.dart';

class FuelTypeRepository {
  final ApiClient apiClient;

  FuelTypeRepository({required this.apiClient});

  Future<FuelTypesResponse> getFuelTypes() async {
    final response = await apiClient.getFuelTypes();

    if (response is! Map) {
      throw Exception('Invalid fuel types API response');
    }

    return FuelTypesResponse.fromJson(Map<String, dynamic>.from(response));
  }
}
