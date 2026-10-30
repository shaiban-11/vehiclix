import 'package:rootysysproject/repositories/models/uploadfiles_model.dart';

abstract class FileUploadState {}

class FileUploadInitial extends FileUploadState {}

class FileUploadLoading extends FileUploadState {}

class FileUploadSuccess extends FileUploadState {
  final FileUploadModel response;

  FileUploadSuccess(this.response);
}

class FileUploadFailure extends FileUploadState {
  final String message;

  FileUploadFailure(this.message);
}
