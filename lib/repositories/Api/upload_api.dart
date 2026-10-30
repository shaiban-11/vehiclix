import 'dart:io';

import 'package:rootysysproject/repositories/Api/api_client.dart';

import 'package:rootysysproject/repositories/models/uploadfiles_model.dart';

class FileUploadRepository {
  final ApiClient apiClient;

  FileUploadRepository({required this.apiClient});

  Future<FileUploadModel> uploadFile({
    required String folder,
    required File file,
  }) async {
    final response = await apiClient.uploadFile(folder: folder, file: file);

    if (response is! Map) {
      throw Exception('Invalid file upload response');
    }

    return FileUploadModel.fromJson(Map<String, dynamic>.from(response));
  }
}
