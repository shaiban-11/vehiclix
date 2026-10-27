import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/repositories/models/updateinspection_model.dart';

class InspectionUpdateRepo {
  final ApiClient apiClient;

  InspectionUpdateRepo({required this.apiClient});

  Future<InspectionUpdateModel> updateInspection({
    required String inspectionId,
    required Map<String, dynamic> inspectionData,
  }) async {
    final response = await apiClient.updateVehicleInspection(
      inspectionId: inspectionId,
      inspectionData: inspectionData,
    );

    if (response is Map<String, dynamic>) {
      return InspectionUpdateModel.fromJson(response);
    }

    if (response is Map) {
      return InspectionUpdateModel.fromJson(
        Map<String, dynamic>.from(response),
      );
    }

    throw Exception('Invalid inspection update response');
  }
}
