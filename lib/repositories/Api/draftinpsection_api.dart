import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/repositories/models/draftinsepction_model.dart';

class DraftInspectionRepository {
  final ApiClient apiClient;

  DraftInspectionRepository({required this.apiClient});

  Future<DraftInspectionModel> getDraftInspections({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await apiClient.getDraftVehicleInspections(
      page: page,
      limit: limit,
    );

    if (response is! Map) {
      throw Exception('Invalid draft inspection response');
    }

    final result = DraftInspectionModel.fromJson(
      Map<String, dynamic>.from(response),
    );

    if (!result.success) {
      throw Exception(
        result.message.isNotEmpty
            ? result.message
            : 'Failed to fetch draft inspections',
      );
    }

    return result;
  }
}
