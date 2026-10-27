import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/repositories/models/inspectiontype_model.dart';

class InspectionRepository {
  final ApiClient apiClient;

  InspectionRepository({required this.apiClient});

  Future<InspectionModel> getInspectionTypes() async {
    final response = await apiClient.getInspectionTypes();

    if (response is Map<String, dynamic>) {
      return InspectionModel.fromJson(response);
    }

    throw Exception('Invalid inspection types response');
  }
}
