part of 'lazada_bloc.dart';

abstract class LazadaEvent extends Equatable {
  const LazadaEvent();
}

class GetPending extends LazadaEvent {
  @override
  List<Object?> get props => [];
}

class GetRts extends LazadaEvent {
  @override
  List<Object?> get props => [];
}

class GetPacked extends LazadaEvent {
  @override
  List<Object?> get props => [];
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
