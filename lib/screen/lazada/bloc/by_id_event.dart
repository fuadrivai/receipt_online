part of 'by_id_bloc.dart';

abstract class ByIdEvent extends Equatable {
  const ByIdEvent();
}

class GetOrderById extends ByIdEvent {
  final String orderSn;
  const GetOrderById(this.orderSn);

  @override
  List<Object?> get props => [orderSn];
}

class LazadaStandBy extends ByIdEvent {
  @override
  List<Object?> get props => [];
}

class LazadaRtsEvent extends ByIdEvent {
  final TransactionOnline data;
  const LazadaRtsEvent(this.data);
  @override
  List<Object?> get props => [data];
}
