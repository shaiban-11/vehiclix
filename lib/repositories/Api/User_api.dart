import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/repositories/models/User_model.dart';

class UserRepository {
  final ApiClient apiClient;

  UserRepository({required this.apiClient});

  Future<UserModel> getUser() async {
    final response = await apiClient.getUser();

    if (response is Map<String, dynamic>) {
      return UserModel.fromJson(response);
    }

    throw Exception('Invalid user response from server');
  }
}
