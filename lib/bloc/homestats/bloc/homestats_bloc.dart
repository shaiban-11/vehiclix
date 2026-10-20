import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rootysysproject/bloc/homestats/bloc/homestats_event.dart';
import 'package:rootysysproject/bloc/homestats/bloc/homestats_state.dart';
import 'package:rootysysproject/repositories/Api/homestats_api.dart';

class HomeStatsBloc extends Bloc<HomeStatsEvent, HomeStatsState> {
  final HomeStatsRepository repository;

  HomeStatsBloc({required this.repository}) : super(const HomeStatsInitial()) {
    on<HomeStatsFetchRequested>(_onFetchHomeStats);
  }

  Future<void> _onFetchHomeStats(
    HomeStatsFetchRequested event,
    Emitter<HomeStatsState> emit,
  ) async {
    emit(const HomeStatsLoading());

    try {
      final response = await repository.fetchHomeStats();

      if (response.success == false) {
        emit(
          HomeStatsFailure(
            response.message ?? 'Failed to load home statistics',
          ),
        );
        return;
      }

      emit(HomeStatsSuccess(response));
    } catch (e) {
      emit(HomeStatsFailure(e.toString()));
    }
  }
}
