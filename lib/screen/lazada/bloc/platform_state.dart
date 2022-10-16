part of 'platform_bloc.dart';

abstract class PlatformState extends Equatable {
  const PlatformState();
}

class PlatformError extends PlatformState {
  @override
  List<Object?> get props => [];
}

class PlatformLoading extends PlatformState {
  @override
  List<Object?> get props => [];
}

class PlatformOrder extends PlatformState {
  final Order order;
  const PlatformOrder(this.order);
  @override
  List<Object?> get props => [order];
}
