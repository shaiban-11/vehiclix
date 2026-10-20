import 'package:rootysysproject/repositories/models/Brands_model.dart';

abstract class BrandState {}

class BrandInitial extends BrandState {}

class BrandLoading extends BrandState {}

class BrandSuccess extends BrandState {
  final BrandResponse brandResponse;

  BrandSuccess(this.brandResponse);
}

class BrandFailure extends BrandState {
  final String message;

  BrandFailure(this.message);
}
