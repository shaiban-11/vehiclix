import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rootysysproject/bloc/Brands/bloc/brands_event.dart';
import 'package:rootysysproject/bloc/Brands/bloc/brands_state.dart';
import 'package:rootysysproject/repositories/Api/brand_api.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository brandRepository;

  BrandBloc({required this.brandRepository}) : super(BrandInitial()) {
    on<BrandsFetchRequested>(_onBrandsFetchRequested);
  }

  Future<void> _onBrandsFetchRequested(
    BrandsFetchRequested event,
    Emitter<BrandState> emit,
  ) async {
    emit(BrandLoading());

    try {
      final response = await brandRepository.getBrands(
        page: event.page,
        limit: event.limit,
        search: event.search,
      );

      if (response.success == true) {
        emit(BrandSuccess(response));
      } else {
        emit(BrandFailure('Failed to load brands'));
      }
    } catch (e) {
      emit(BrandFailure(e.toString()));
    }
  }
}
