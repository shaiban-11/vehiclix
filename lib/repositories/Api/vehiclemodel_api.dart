import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/models/Vehicle_model.dart';

class VehicleModelRepository {
  final ApiClient apiClient;

  VehicleModelRepository({required this.apiClient});

  Future<VehicleModel> getVehicleModels() async {
    final response = await apiClient.getVehicleModels();

    if (response is Map) {
      return VehicleModel.fromJson(Map<String, dynamic>.from(response));
    }

    throw Exception('Invalid vehicle models API response');
  }
}
