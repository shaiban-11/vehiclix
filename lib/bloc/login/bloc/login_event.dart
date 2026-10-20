import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final String ip;
  final String device;

  const LoginSubmitted({
    required this.email,
    required this.password,
    required this.ip,
    required this.device,
  });

  @override
  List<Object?> get props => [email, password, ip, device];
}

class LoginReset extends LoginEvent {}
