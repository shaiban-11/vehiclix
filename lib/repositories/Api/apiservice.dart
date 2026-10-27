import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:rootysysproject/utils/App_constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString(AppConstants.tokenKey) ?? '';

    print("========== TOKEN CHECK ==========");
    print("Token: $token");
    print("Token length: ${token.length}");

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    print("========== HEADERS ==========");
    print(headers);

    return headers;
  }

  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool needsAuth = false,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}$endpoint');

    final headers = needsAuth
        ? await _getHeaders()
        : {'Content-Type': 'application/json', 'Accept': 'application/json'};

    print("========== POST DEBUG ==========");
    print("URL: $url");
    print("HEADERS: $headers");
    print("BODY: ${jsonEncode(body)}");

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  static Future<dynamic> get(String endpoint, {bool needsAuth = true}) async {
    final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
    final headers = needsAuth
        ? await _getHeaders()
        : {'Content-Type': 'application/json', 'Accept': 'application/json'};
    final response = await http.get(url, headers: headers);
    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    print('STATUS CODE: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return response.body;
      }
    } else {
      throw Exception('Server error: ${response.statusCode}\n${response.body}');
    }
  }
}
