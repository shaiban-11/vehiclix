import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/bloc/country_spec.dart/bloc/countryspec_event.dart';
import 'package:rootysysproject/bloc/country_spec.dart/bloc/countryspec_state.dart';
import 'package:rootysysproject/repositories/Api/counteryspec_api.dart';

class CountrySpecBloc extends Bloc<CountrySpecEvent, CountrySpecState> {
  final CountrySpecRepository countrySpecRepository;

  CountrySpecBloc({required this.countrySpecRepository})
    : super(const CountrySpecInitial()) {
    on<CountrySpecFetchRequested>(_onFetchCountrySpecs);
  }

  Future<void> _onFetchCountrySpecs(
    CountrySpecFetchRequested event,
    Emitter<CountrySpecState> emit,
  ) async {
    emit(const CountrySpecLoading());

    try {
      final response = await countrySpecRepository.fetchCountrySpecs();

      if (response.success == false) {
        emit(const CountrySpecFailure('Failed to load country specifications'));
        return;
      }

      emit(CountrySpecSuccess(response));
    } catch (e) {
      emit(CountrySpecFailure(e.toString()));
    }
  }
}
