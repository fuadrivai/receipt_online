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

class LoadingSingle extends PlatformState {
  @override
  List<Object?> get props => [];
}

class PlatformLoaded extends PlatformState {
  final FullOrder fullOrder;
  const PlatformLoaded(this.fullOrder);
  @override
  List<Object?> get props => [fullOrder];
}

class PlatformOrder extends PlatformState {
  final Order order;
  const PlatformOrder(this.order);
  @override
  List<Object?> get props => [order];
}
