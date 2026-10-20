import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/models/home_stats_model.dart';

class HomeStatsRepository {
  final ApiClient apiClient;

  HomeStatsRepository({required this.apiClient});

  Future<HomeStatsModel> fetchHomeStats() async {
    try {
      final response = await apiClient.getHomeStatistics();

      if (response is Map) {
        return HomeStatsModel.fromJson(Map<String, dynamic>.from(response));
      }

      throw Exception('Invalid home statistics response');
    } catch (e) {
      rethrow;
    }
  }
}
