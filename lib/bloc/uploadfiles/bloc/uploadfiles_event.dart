import 'dart:io';

abstract class FileUploadEvent {}

class FileUploadRequested extends FileUploadEvent {
  final String folder;
  final File file;

  FileUploadRequested({required this.folder, required this.file});
}
