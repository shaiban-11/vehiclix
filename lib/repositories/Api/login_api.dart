import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/models/login_model.dart';
import 'package:rootysysproject/utils/App_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  final ApiClient apiClient;

  LoginApi(this.apiClient);

  Future<LoginModel> login({
    required String email,
    required String password,
    required String ip,
    required String device,
  }) async {
    try {
      final response = await apiClient.login(
        email: email,
        password: password,
        ip: ip,
        device: device,
      );

      if (response is! Map) {
        throw Exception('Invalid login response from server');
      }

      final loginModel = LoginModel.fromJson(
        Map<String, dynamic>.from(response),
      );

      if (loginModel.success == true) {
        final accessToken = loginModel.data?.accessToken;
        final refreshToken = loginModel.data?.refreshToken;

        if (accessToken != null && accessToken.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();

          await prefs.setString(AppConstants.tokenKey, accessToken);

          if (refreshToken != null && refreshToken.isNotEmpty) {
            await prefs.setString('refreshToken', refreshToken);
          }
        }
      }

      return loginModel;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
