import 'package:equatable/equatable.dart';

abstract class CountrySpecEvent extends Equatable {
  const CountrySpecEvent();

  @override
  List<Object?> get props => [];
}

class CountrySpecFetchRequested extends CountrySpecEvent {
  const CountrySpecFetchRequested();
}
