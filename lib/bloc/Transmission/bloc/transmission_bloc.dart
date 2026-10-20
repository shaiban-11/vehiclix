import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/bloc/Transmission/bloc/transmission_event.dart';
import 'package:rootysysproject/bloc/Transmission/bloc/transmission_state.dart';
import 'package:rootysysproject/repositories/Api/Transmission_api.dart';

class TransmissionBloc extends Bloc<TransmissionEvent, TransmissionState> {
  final TransmissionRepository transmissionRepository;

  TransmissionBloc({required this.transmissionRepository})
    : super(TransmissionInitial()) {
    on<TransmissionFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    TransmissionFetchRequested event,
    Emitter<TransmissionState> emit,
  ) async {
    emit(TransmissionLoading());

    try {
      final response = await transmissionRepository.getTransmissions();

      if (response.success == true) {
        emit(TransmissionSuccess(response));
      } else {
        emit(TransmissionFailure('Failed to load transmissions'));
      }
    } catch (e) {
      emit(TransmissionFailure(e.toString()));
    }
  }
}
