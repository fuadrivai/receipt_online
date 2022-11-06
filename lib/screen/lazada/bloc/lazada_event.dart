part of 'lazada_bloc.dart';

abstract class LazadaEvent extends Equatable {
  const LazadaEvent();
}

class GetOrders extends LazadaEvent {
  final int tab;
  final String sorting;
  final String status;
  const GetOrders(this.tab, this.sorting, this.status);
  @override
  List<Object?> get props => [tab, sorting, status];
}

class OnChangeSortingEvent extends LazadaEvent {
  final int tab;
  final String sorting;
  const OnChangeSortingEvent(this.sorting, this.tab);
  @override
  List<Object?> get props => [sorting, tab];
}

class OnRefresh extends LazadaEvent {
  final int tab;
  const OnRefresh(this.tab);
  @override
  List<Object?> get props => [tab];
}
