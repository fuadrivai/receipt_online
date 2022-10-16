part of 'platform_bloc.dart';

abstract class PlatformEvent extends Equatable {
  const PlatformEvent();
}

class PlatformFullOder extends PlatformEvent {
  @override
  List<Object?> get props => [];
}

class PlatformSingleOrder extends PlatformEvent {
  final int orderId;
  const PlatformSingleOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
