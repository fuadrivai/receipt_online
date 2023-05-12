part of 'tiktok_bloc.dart';

abstract class TiktokEvent extends Equatable {
  const TiktokEvent();
}

class GetOrders extends TiktokEvent {
  const GetOrders();
  @override
  List<Object?> get props => [];
}

class GetOrder extends TiktokEvent {
  final List<String> orderNumbers;
  const GetOrder(this.orderNumbers);
  @override
  List<Object?> get props => [orderNumbers];
}
