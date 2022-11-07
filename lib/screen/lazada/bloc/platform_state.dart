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
  final TransactionOnline transaction;
  const PlatformOrder(this.transaction);
  @override
  List<Object?> get props => [transaction];
}
