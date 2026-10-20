import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/models/Brands_model.dart';

class BrandRepository {
  final ApiClient apiClient;

  BrandRepository({required this.apiClient});

  Future<BrandResponse> getBrands({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    final response = await apiClient.getBrands(
      page: page,
      limit: limit,
      search: search,
    );

    if (response is! Map) {
      throw Exception('Invalid brands API response');
    }

    return BrandResponse.fromJson(Map<String, dynamic>.from(response));
  }
}
