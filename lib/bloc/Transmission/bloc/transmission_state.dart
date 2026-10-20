import 'package:rootysysproject/repositories/models/transmission_model.dart';

abstract class TransmissionState {}

class TransmissionInitial extends TransmissionState {}

class TransmissionLoading extends TransmissionState {}

class TransmissionSuccess extends TransmissionState {
  final TransmissionModel transmissionResponse;

  TransmissionSuccess(this.transmissionResponse);
}

class TransmissionFailure extends TransmissionState {
  final String message;

  TransmissionFailure(this.message);
}
