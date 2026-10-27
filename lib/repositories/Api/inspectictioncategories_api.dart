import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/repositories/models/inspectioncategoryandfileds_model.dart';

class InspectionDetailsRepository {
  final ApiClient apiClient;

  InspectionDetailsRepository({required this.apiClient});

  Future<InspectionDetailsModel> getInspectionDataFields({
    required String vehicleId,
    required String typeItemId,
  }) async {
    final response = await apiClient.getInspectionDataFields(
      vehicleId: vehicleId,
      typeItemId: typeItemId,
    );

    if (response is Map) {
      return InspectionDetailsModel.fromJson(
        Map<String, dynamic>.from(response),
      );
    }

    throw Exception('Invalid inspection details response');
  }
}
