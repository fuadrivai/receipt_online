part of 'platform_bloc.dart';

abstract class PlatformEvent extends Equatable {
  const PlatformEvent();
}

class PlatformSingleOrder extends PlatformEvent {
  final Order order;
  const PlatformSingleOrder(this.order);

  @override
  List<Object?> get props => [order];
}

class PlatformRTS extends PlatformEvent {
  final Order order;
  const PlatformRTS(this.order);

  @override
  List<Object?> get props => [order];
}
