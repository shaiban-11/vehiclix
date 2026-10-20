import 'package:rootysysproject/repositories/models/User_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final UserModel user;

  UserSuccess(this.user);
}

class UserFailure extends UserState {
  final String message;

  UserFailure(this.message);
}
