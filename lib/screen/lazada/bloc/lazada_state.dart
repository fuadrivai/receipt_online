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

class LazadaFullOrderState extends LazadaState {
  final FullOrder fullOrder;
  const LazadaFullOrderState(this.fullOrder);
  @override
  List<Object?> get props => [fullOrder];
}
