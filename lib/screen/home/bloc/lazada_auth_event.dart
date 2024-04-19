part of 'lazada_auth_bloc.dart';

abstract class LazadaAuthEvent extends Equatable {
  const LazadaAuthEvent();

  @override
  List<Object> get props => [];
}

class OnGetLink extends LazadaAuthEvent {
  const OnGetLink();
}
