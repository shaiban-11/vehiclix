import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/models/transmission_model.dart';

class TransmissionRepository {
  final ApiClient apiClient;

  TransmissionRepository({required this.apiClient});

  Future<TransmissionModel> getTransmissions() async {
    final response = await apiClient.getTransmissions();

    if (response is! Map) {
      throw Exception('Invalid transmission API response');
    }

    return TransmissionModel.fromJson(Map<String, dynamic>.from(response));
  }
}
