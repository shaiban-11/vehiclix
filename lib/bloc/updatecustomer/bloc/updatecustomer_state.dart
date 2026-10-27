import 'package:rootysysproject/repositories/models/updatecustomer_model.dart';

abstract class CustomerUpdateState {}

class CustomerUpdateInitial extends CustomerUpdateState {}

class CustomerUpdateLoading extends CustomerUpdateState {}

class CustomerUpdateSuccess extends CustomerUpdateState {
  final CustomerUpdateModel response;

  CustomerUpdateSuccess(this.response);
}

class CustomerUpdateFailure extends CustomerUpdateState {
  final String message;

  CustomerUpdateFailure(this.message);
}
