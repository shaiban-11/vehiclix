import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

class CustomerFetchRequested extends CustomerEvent {
  final int page;
  final int limit;

  const CustomerFetchRequested({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}
