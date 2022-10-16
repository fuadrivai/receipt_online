part of 'lazada_bloc.dart';

abstract class LazadaEvent extends Equatable {
  const LazadaEvent();
}

class GetFullOrderEvent extends LazadaEvent {
  @override
  List<Object?> get props => [];
}
