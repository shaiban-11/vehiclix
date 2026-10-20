import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/repositories/models/Vehicle_verients.dart';

class VehicleVarientsRepository {
  final ApiClient apiClient;

  VehicleVarientsRepository({required this.apiClient});

  Future<VehicleVarientsModel> fetchVehicleVarients({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    final response = await apiClient.getVehicleVariants(
      page: page,
      limit: limit,
      search: search,
    );

    if (response is! Map) {
      throw Exception('Invalid vehicle variants API response');
    }

    return VehicleVarientsModel.fromJson(Map<String, dynamic>.from(response));
  }
}
