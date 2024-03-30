part of 'product_checker_bloc.dart';

abstract class ProductCheckerEvent extends Equatable {
  const ProductCheckerEvent();
}

class ProductCheckerInitialEvent extends ProductCheckerEvent {
  @override
  List<Object?> get props => [];
}

class ProductCheckerStandByEvent extends ProductCheckerEvent {
  @override
  List<Object?> get props => [];
}

class ProductCheckerLoadingEvent extends ProductCheckerEvent {
  @override
  List<Object?> get props => [];
}

class ProductCheckerOnTabEvent extends ProductCheckerEvent {
  final Platform platform;
  const ProductCheckerOnTabEvent(this.platform);
  @override
  List<Object?> get props => [platform];
}

class GetOrderEvent extends ProductCheckerEvent {
  final Platform platform;
  final String orderSn;
  const GetOrderEvent(this.platform, this.orderSn);
  @override
  List<Object?> get props => [platform, orderSn];
}

class RtsEvent extends ProductCheckerEvent {
  final Platform platform;
  final TransactionOnline dataOrder;
  const RtsEvent(this.platform, this.dataOrder);
  @override
  List<Object?> get props => [platform, dataOrder];
}

class CreateOrderEvent extends ProductCheckerEvent {
  final Platform platform;
  final TransactionOnline dataOrder;
  const CreateOrderEvent(this.platform, this.dataOrder);
  @override
  List<Object?> get props => [platform, dataOrder];
}
