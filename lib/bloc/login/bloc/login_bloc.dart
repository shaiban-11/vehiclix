import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/repositories/Api/login_api.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginApi authRepository;

  LoginBloc(this.authRepository) : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>((_, emit) => emit(const LoginState()));
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));

    try {
      final result = await authRepository.login(
        email: event.email,
        password: event.password,
        ip: event.ip,
        device: event.device,
      );

      if (result.success == true) {
        emit(state.copyWith(status: LoginStatus.success, loginData: result));
      } else {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: result.message ?? 'Login failed',
          ),
        );
      }
    } on ApiException catch (e) {
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.message),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Unexpected error: $e',
        ),
      );
    }
  }
}
