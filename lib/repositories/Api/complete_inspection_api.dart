import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/models/completeinspection_model.dart';

class CompletedInspectionRepository {
  final ApiClient apiClient;

  CompletedInspectionRepository({required this.apiClient});

  // Fetch completed inspections
  Future<CompletedInspectionModel> fetchCompletedInspections({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await apiClient.getCompletedVehicleInspections(
      page: page,
      limit: limit,
    );

    if (response is! Map) {
      throw Exception('Invalid completed inspections response');
    }

    return CompletedInspectionModel.fromJson(
      Map<String, dynamic>.from(response),
    );
  }

  // Complete a specific inspection
  Future<CompletedInspectionModel> completeInspection(
    String inspectionId,
  ) async {
    final response = await apiClient.completeVehicleInspection(inspectionId);

    if (response is! Map) {
      throw Exception('Invalid inspection completion response');
    }

    return CompletedInspectionModel.fromJson(
      Map<String, dynamic>.from(response),
    );
  }
}
