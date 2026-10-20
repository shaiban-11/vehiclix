import 'package:equatable/equatable.dart';

import 'package:rootysysproject/repositories/models/countryspec_model.dart';

abstract class CountrySpecState extends Equatable {
  const CountrySpecState();

  @override
  List<Object?> get props => [];
}

class CountrySpecInitial extends CountrySpecState {
  const CountrySpecInitial();
}

class CountrySpecLoading extends CountrySpecState {
  const CountrySpecLoading();
}

class CountrySpecSuccess extends CountrySpecState {
  final CountrySpecModel countrySpecResponse;

  const CountrySpecSuccess(this.countrySpecResponse);

  @override
  List<Object?> get props => [countrySpecResponse];
}

class CountrySpecFailure extends CountrySpecState {
  final String message;

  const CountrySpecFailure(this.message);

  @override
  List<Object?> get props => [message];
}
