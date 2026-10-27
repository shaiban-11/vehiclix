import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/models/inspectiondetails_model.dart';

class VehicleInspectionRepository {
  final ApiClient apiClient;

  VehicleInspectionRepository({required this.apiClient});

  Future<VehicleInspectionModel> getVehicleInspection(
    String inspectionId,
  ) async {
    final response = await apiClient.getVehicleInspection(inspectionId);

    if (response is! Map) {
      throw Exception('Invalid inspection response');
    }

    final result = VehicleInspectionModel.fromJson(
      Map<String, dynamic>.from(response),
    );

    if (!result.success) {
      throw Exception(
        result.message.isNotEmpty
            ? result.message
            : 'Failed to fetch inspection details',
      );
    }

    return result;
  }
}
