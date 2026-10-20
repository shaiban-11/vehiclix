import 'package:equatable/equatable.dart';
import 'package:rootysysproject/repositories/models/login_model.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final LoginModel? loginData;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.loginData,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    LoginModel? loginData,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      loginData: loginData ?? this.loginData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, loginData, errorMessage];
}
