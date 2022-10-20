part of 'lazada_bloc.dart';

abstract class LazadaState extends Equatable {
  const LazadaState();
}

class LazadaErrorState extends LazadaState {
  @override
  List<Object?> get props => [];
}

class LazadaLoadingState extends LazadaState {
  @override
  List<Object?> get props => [];
}

class LazadaOnChangeState extends LazadaState {
  final int tab;
  final String sorting;
  const LazadaOnChangeState(this.sorting, this.tab);
  @override
  List<Object?> get props => [sorting, tab];
}

class LazadaFullOrderState extends LazadaState {
  final FullOrder fullOrder;
  const LazadaFullOrderState(this.fullOrder);
  @override
  List<Object?> get props => [fullOrder];
}
