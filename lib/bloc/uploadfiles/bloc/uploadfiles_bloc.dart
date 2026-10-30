import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rootysysproject/bloc/uploadfiles/bloc/uploadfiles_event.dart';
import 'package:rootysysproject/bloc/uploadfiles/bloc/uploadfiles_state.dart';
import 'package:rootysysproject/repositories/Api/upload_api.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  final FileUploadRepository repository;

  FileUploadBloc({required this.repository}) : super(FileUploadInitial()) {
    on<FileUploadRequested>(_onFileUploadRequested);
  }

  Future<void> _onFileUploadRequested(
    FileUploadRequested event,
    Emitter<FileUploadState> emit,
  ) async {
    emit(FileUploadLoading());

    try {
      final response = await repository.uploadFile(
        folder: event.folder,
        file: event.file,
      );

      if (response.success == true && response.data?.url != null) {
        emit(FileUploadSuccess(response));
      } else {
        emit(FileUploadFailure(response.message ?? 'File upload failed'));
      }
    } catch (e) {
      emit(FileUploadFailure(e.toString()));
    }
  }
}
