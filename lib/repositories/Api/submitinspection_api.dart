import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/repositories/models/submitinspection_model.dart';

class InspectionSubmitRepo {
  final ApiClient apiClient;

  InspectionSubmitRepo({required this.apiClient});

  Future<dynamic> submitInspection(InspectionSubmitModel inspection) async {
    try {
      final response = await apiClient.submitVehicleInspection(
        inspection.toJson(),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
