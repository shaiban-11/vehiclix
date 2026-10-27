import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rootysysproject/utils/App_constants.dart';

class ApiClient {
  final http.Client _client;
  String? accessToken;

  ApiClient({String? accessToken, http.Client? client})
    : accessToken = accessToken,
      _client = client ?? http.Client();

  // --------------------------------------------------
  // BUILD URL
  // --------------------------------------------------

  Uri _buildUri(String endpoint, {Map<String, dynamic>? queryParameters}) {
    final baseUrl = AppConstants.baseUrl.replaceFirst(RegExp(r'/+$'), '');
    final cleanEndpoint = endpoint.replaceAll(RegExp(r'^/+'), '');

    final uri = Uri.parse('$baseUrl/$cleanEndpoint');

    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }

    final params = <String, String>{};

    queryParameters.forEach((key, value) {
      if (value != null) {
        params[key] = value.toString();
      }
    });

    return uri.replace(queryParameters: params);
  }

  // --------------------------------------------------
  // LOAD SAVED TOKEN
  // --------------------------------------------------

  Future<String?> _getSavedToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null && token.trim().isNotEmpty) {
        return token.trim();
      }

      return null;
    } catch (e) {
      debugPrint('TOKEN: Unable to read saved token: $e');
      return null;
    }
  }

  // --------------------------------------------------
  // HEADERS
  // --------------------------------------------------

  Map<String, String> _headers({
    bool jsonContentType = true,
    bool includeAuth = true,
  }) {
    final headers = <String, String>{'Accept': 'application/json'};

    if (jsonContentType) {
      headers['Content-Type'] = 'application/json';
    }

    final token = accessToken?.trim();

    if (includeAuth && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // --------------------------------------------------
  // RESPONSE HANDLING
  // --------------------------------------------------

  dynamic _decodeResponse(http.Response response) {
    final responseBody = response.body.trim();

    dynamic decoded;

    if (responseBody.isEmpty) {
      decoded = null;
    } else {
      try {
        decoded = jsonDecode(responseBody);
      } on FormatException {
        decoded = responseBody;
      }
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'Request failed';

      if (decoded is Map) {
        message =
            decoded['message']?.toString() ??
            decoded['error']?.toString() ??
            message;
      } else if (decoded is String && decoded.isNotEmpty) {
        message = decoded;
      }

      throw ApiException(
        message: message,
        statusCode: response.statusCode,
        responseData: decoded,
      );
    }

    return decoded;
  }

  // --------------------------------------------------
  // COMMON API REQUEST
  // --------------------------------------------------

  Future<dynamic> _request({
    required String method,
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    final uri = _buildUri(endpoint, queryParameters: queryParameters);

    // Load token from SharedPreferences if authentication is required.
    if (includeAuth && (accessToken == null || accessToken!.trim().isEmpty)) {
      accessToken = await _getSavedToken();
    }

    final headers = _headers(includeAuth: includeAuth);

    // Debug information. Never print the actual token.
    debugPrint('API METHOD: ${method.toUpperCase()}');
    debugPrint('API URL: $uri');
    debugPrint('AUTH ENABLED: $includeAuth');
    debugPrint(
      'TOKEN AVAILABLE: ${accessToken != null && accessToken!.trim().isNotEmpty}',
    );
    debugPrint('AUTH HEADER ADDED: ${headers.containsKey('Authorization')}');

    final encodedBody = body == null ? null : jsonEncode(body);

    late http.Response response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await _client.get(uri, headers: headers);
        break;

      case 'POST':
        response = await _client.post(uri, headers: headers, body: encodedBody);
        break;

      case 'PUT':
        response = await _client.put(uri, headers: headers, body: encodedBody);
        break;

      case 'PATCH':
        response = await _client.patch(
          uri,
          headers: headers,
          body: encodedBody,
        );
        break;

      case 'DELETE':
        response = await _client.delete(
          uri,
          headers: headers,
          body: encodedBody,
        );
        break;

      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }

    debugPrint('API STATUS: ${response.statusCode}');

    return _decodeResponse(response);
  }

  // --------------------------------------------------
  // LOGIN
  // --------------------------------------------------

  Future<dynamic> login({
    required String email,
    required String password,
    required String ip,
    required String device,
  }) async {
    // Login request does not require an existing token.
    final result = await _request(
      method: 'POST',
      endpoint: AppConstants.loginEndpoint,
      includeAuth: false,
      body: {'email': email, 'password': password, 'ip': ip, 'device': device},
    );

    if (result is Map) {
      final data = result['data'];

      dynamic token;

      // Token inside data.
      if (data is Map) {
        token = data['accessToken'] ?? data['access_token'] ?? data['token'];
      }

      // Token at the top level.
      token ??=
          result['accessToken'] ?? result['access_token'] ?? result['token'];

      if (token is String && token.trim().isNotEmpty) {
        accessToken = token.trim();

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('auth_token', accessToken!);

        debugPrint('LOGIN: Access token saved successfully');
      } else {
        accessToken = null;

        debugPrint(
          'LOGIN: Token not found. Check the login response structure.',
        );
      }
    }

    return result;
  }

  // --------------------------------------------------
  // USER
  // --------------------------------------------------

  Future<dynamic> getUser() {
    return _request(method: 'GET', endpoint: AppConstants.userEndpoint);
  }

  // --------------------------------------------------
  // BRANDS
  // --------------------------------------------------

  Future<dynamic> getBrands({int page = 1, int limit = 10, String? search}) {
    return _request(
      method: 'GET',
      endpoint: AppConstants.brandsEndpoint,
      queryParameters: {'page': page, 'limit': limit, 'search': search},
    );
  }

  // --------------------------------------------------
  // FUEL TYPES
  // --------------------------------------------------

  Future<dynamic> getFuelTypes() {
    return _request(method: 'GET', endpoint: AppConstants.fueltypesEndpoint);
  }

  // --------------------------------------------------
  // TRANSMISSIONS
  // --------------------------------------------------

  Future<dynamic> getTransmissions() {
    return _request(method: 'GET', endpoint: AppConstants.transmissionEndpoint);
  }

  // --------------------------------------------------
  // VEHICLE MODELS
  // --------------------------------------------------

  Future<dynamic> getVehicleModels({
    int page = 1,
    int limit = 10,
    String? search,
  }) {
    return _request(
      method: 'GET',
      endpoint: AppConstants.vehiclemodelsEndpoint,
      queryParameters: {'page': page, 'limit': limit, 'search': search},
    );
  }

  Future<dynamic> getModelsByBrand(String brandId) {
    return _request(
      method: 'GET',
      endpoint: '${AppConstants.vehiclemodelsEndpoint}/brand/$brandId',
    );
  }

  // --------------------------------------------------
  // VEHICLE VARIANTS
  // --------------------------------------------------

  Future<dynamic> getVehicleVariants({
    int page = 1,
    int limit = 10,
    String? search,
  }) {
    return _request(
      method: 'GET',
      endpoint: AppConstants.vehiclevarientsEndpoint,
      queryParameters: {'page': page, 'limit': limit, 'search': search},
    );
  }

  Future<dynamic> getVariantsByModel(String modelId) {
    return _request(
      method: 'GET',
      endpoint: '${AppConstants.vehiclevarientsEndpoint}/model/$modelId',
    );
  }

  // --------------------------------------------------
  // COUNTRY SPECIFICATIONS
  // --------------------------------------------------

  Future<dynamic> getCountrySpecifications() {
    return _request(
      method: 'GET',
      endpoint: AppConstants.CountryspecificationEndpoint,
    );
  }

  // --------------------------------------------------
  // CUSTOMERS
  // --------------------------------------------------

  // CREATE CUSTOMER
  Future<dynamic> createCustomer({required Map<String, dynamic> body}) {
    return _request(
      method: 'POST',
      endpoint: AppConstants.CustomerEndpoint,
      body: body,
    );
  }

  // GET CUSTOMERS
  Future<dynamic> getCustomers({int page = 1, int limit = 10}) {
    return _request(
      method: 'GET',
      endpoint: AppConstants.CustomerEndpoint,
      queryParameters: {'page': page, 'limit': limit},
    );
  }

  // GET CUSTOMER BY ID
  Future<dynamic> getCustomerById(String customerId) {
    final endpoint = AppConstants.CustomerbyidEndpoint.replaceFirst(
      ':id',
      customerId,
    );

    return _request(method: 'GET', endpoint: endpoint);
  }

  // Existing alias for customer profile requests.
  Future<dynamic> getCustomerProfile(String customerId) {
    return getCustomerById(customerId);
  }

  // UPDATE CUSTOMER
  Future<dynamic> updateCustomer({
    required String customerId,
    required Map<String, dynamic> customerData,
  }) {
    final endpoint = AppConstants.CustomerbyidEndpoint.replaceFirst(
      ':id',
      customerId,
    );

    return _request(method: 'PUT', endpoint: endpoint, body: customerData);
  }

  // --------------------------------------------------
  // CUSTOMER VEHICLES
  // --------------------------------------------------

  String _customerVehiclesEndpoint(String customerId) {
    return AppConstants.CustomervehiclesEndpoint.replaceFirst(
      ':customerId',
      customerId,
    );
  }

  Future<dynamic> getCustomerVehicles(String customerId) {
    return _request(
      method: 'GET',
      endpoint: _customerVehiclesEndpoint(customerId),
    );
  }

  Future<dynamic> createCustomerVehicle({
    required String customerId,
    required Map<String, dynamic> body,
  }) async {
    final endpoint = AppConstants.CustomervehiclesEndpoint.replaceAll(
      ':customerId',
      customerId,
    );

    return _request(method: 'POST', endpoint: endpoint, body: body);
  }

  Future<dynamic> updateCustomerVehicle({
    required String customerId,
    required String vehicleId,
    required Map<String, dynamic> vehicleData,
  }) {
    return _request(
      method: 'PUT',
      endpoint: '${_customerVehiclesEndpoint(customerId)}/$vehicleId',
      body: vehicleData,
    );
  }

  Future<dynamic> deleteCustomerVehicle({
    required String customerId,
    required String vehicleId,
  }) {
    return _request(
      method: 'DELETE',
      endpoint: '${_customerVehiclesEndpoint(customerId)}/$vehicleId',
    );
  }

  // --------------------------------------------------
  // INSPECTION TYPES
  // --------------------------------------------------

  Future<dynamic> getInspectionTypes() {
    return _request(
      method: 'GET',
      endpoint: AppConstants.inspectiontypesEndpoint,
    );
  }

  // --------------------------------------------------
  // INSPECTION DATA FIELDS
  // --------------------------------------------------

  Future<dynamic> getInspectionDataFields({
    required String vehicleId,
    required String typeItemId,
  }) {
    return _request(
      method: 'GET',
      endpoint: 'app/inspections/data-fields/$vehicleId',
      queryParameters: {'typeItemId': typeItemId},
    );
  }

  // --------------------------------------------------
  // VEHICLE INSPECTIONS
  // --------------------------------------------------

  Future<dynamic> submitVehicleInspection(Map<String, dynamic> inspectionData) {
    return _request(
      method: 'POST',
      endpoint: 'app/vehicle-inspections/submit',
      body: inspectionData,
    );
  }

  Future<dynamic> updateVehicleInspection({
    required String inspectionId,
    required Map<String, dynamic> inspectionData,
  }) {
    return _request(
      method: 'PUT',
      endpoint: 'app/vehicle-inspections/$inspectionId',
      body: inspectionData,
    );
  }

  Future<dynamic> completeVehicleInspection(String inspectionId) {
    return _request(
      method: 'PUT',
      endpoint: 'app/vehicle-inspections/$inspectionId/complete',
    );
  }

  Future<dynamic> getVehicleInspection(String inspectionId) {
    return _request(
      method: 'GET',
      endpoint: 'app/vehicle-inspections/$inspectionId',
    );
  }

  Future<dynamic> getDraftVehicleInspections({int page = 1, int limit = 10}) {
    return _request(
      method: 'GET',
      endpoint: 'app/vehicle-inspections/drafts',
      queryParameters: {'page': page, 'limit': limit},
    );
  }

  Future<dynamic> getCompletedVehicleInspections({
    int page = 1,
    int limit = 10,
  }) {
    return _request(
      method: 'GET',
      endpoint: 'app/vehicle-inspections/completed',
      queryParameters: {'page': page, 'limit': limit},
    );
  }

  // --------------------------------------------------
  // FILE UPLOAD
  // --------------------------------------------------

  Future<dynamic> uploadFile({
    required String folder,
    required File file,
  }) async {
    final endpoint = AppConstants.UploadEndpoint.replaceFirst(
      ':folder',
      folder,
    );

    final uri = _buildUri(endpoint);

    // Load saved token before uploading.
    if (accessToken == null || accessToken!.trim().isEmpty) {
      accessToken = await _getSavedToken();
    }

    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll(_headers(jsonContentType: false));

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    debugPrint('UPLOAD STATUS: ${response.statusCode}');

    return _decodeResponse(response);
  }

  // --------------------------------------------------
  // HOME STATISTICS
  // --------------------------------------------------

  Future<dynamic> getHomeStatistics() {
    return _request(
      method: 'GET',
      endpoint: AppConstants.HomeStatisticsEndpoint,
    );
  }

  // --------------------------------------------------
  // LOGOUT / CLEAR TOKEN
  // --------------------------------------------------

  Future<void> clearToken() async {
    accessToken = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    debugPrint('AUTH: Saved token cleared');
  }

  // --------------------------------------------------
  // CLOSE CLIENT
  // --------------------------------------------------

  void close() {
    _client.close();
  }
}

// --------------------------------------------------
// API EXCEPTION
// --------------------------------------------------

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final dynamic responseData;

  ApiException({
    required this.message,
    required this.statusCode,
    this.responseData,
  });

  @override
  String toString() {
    return 'ApiException ($statusCode): $message';
  }
}
