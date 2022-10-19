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
