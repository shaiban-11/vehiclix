class ApiException implements Exception {
  String message;
  String statuscode;
  ApiException({required this.message, required this.statuscode});
  @override
  String toString() {
    return message;
  }
}
