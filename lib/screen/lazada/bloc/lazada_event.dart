part of 'lazada_bloc.dart';

abstract class LazadaEvent extends Equatable {
  const LazadaEvent();
}

class GetOrders extends LazadaEvent {
  final int tab;
  const GetOrders(this.tab);
  @override
  List<Object?> get props => [tab];
}

class OnChangeSortingEvent extends LazadaEvent {
  final int tab;
  final String sorting;
  const OnChangeSortingEvent(this.sorting, this.tab);
  @override
  List<Object?> get props => [sorting, tab];
}
