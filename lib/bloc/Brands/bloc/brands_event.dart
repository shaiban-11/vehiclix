abstract class BrandEvent {}

class BrandsFetchRequested extends BrandEvent {
  final int page;
  final int limit;
  final String? search;

  BrandsFetchRequested({this.page = 1, this.limit = 10, this.search});
}
