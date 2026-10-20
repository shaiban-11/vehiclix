import 'package:rootysysproject/repositories/models/home_stats_model.dart';

abstract class HomeStatsState {
  const HomeStatsState();
}

class HomeStatsInitial extends HomeStatsState {
  const HomeStatsInitial();
}

class HomeStatsLoading extends HomeStatsState {
  const HomeStatsLoading();
}

class HomeStatsSuccess extends HomeStatsState {
  final HomeStatsModel homeStats;

  const HomeStatsSuccess(this.homeStats);
}

class HomeStatsFailure extends HomeStatsState {
  final String message;

  const HomeStatsFailure(this.message);
}
