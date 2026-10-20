abstract class VehicleVarientsEvent {}

class VehicleVarientsFetchRequested extends VehicleVarientsEvent {
  final int page;
  final int limit;
  final String? search;

  VehicleVarientsFetchRequested({this.page = 1, this.limit = 10, this.search});
}
