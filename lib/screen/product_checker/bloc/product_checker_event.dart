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
  final List<Platform> platforms;
  const ProductCheckerOnTabEvent(this.platform, this.platforms);
  @override
  List<Object?> get props => [platform, platforms];
}

class GetOrderEvent extends ProductCheckerEvent {
  final Platform platform;
  final String orderSn;
  const GetOrderEvent(this.platform, this.orderSn);
  @override
  List<Object?> get props => [platform, orderSn];
}
