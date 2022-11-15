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

class GetOrderEvent extends ProductCheckerEvent {
  final String platform;
  const GetOrderEvent(this.platform);
  @override
  List<Object?> get props => [platform];
}
