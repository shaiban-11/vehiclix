import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/repositories/Api/User_api.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<UserFetchRequested>((event, emit) async {
      emit(UserLoading());

      try {
        final user = await userRepository.getUser();
        emit(UserSuccess(user));
      } catch (e) {
        emit(UserFailure(e.toString()));
      }
    });
  }
}
