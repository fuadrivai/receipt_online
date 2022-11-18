part of 'product_checker_bloc.dart';

abstract class ProductCheckerState extends Equatable {
  const ProductCheckerState();
}

class ProductCheckerStandByState extends ProductCheckerState {
  final List<Platform>? platforms;
  final Platform? platform;
  const ProductCheckerStandByState({this.platforms, this.platform});
  @override
  List<Object?> get props => [platforms, platform];
}

class ProductCheckerDataState extends ProductCheckerState {
  final List<Platform>? platforms;
  final List<TransactionOnline>? data;
  final Platform? platform;
  const ProductCheckerDataState({this.platforms, this.data, this.platform});

  @override
  List<Object?> get props => [platforms, data];
}

class ProductCheckerLoadingState extends ProductCheckerState {
  @override
  List<Object?> get props => [];
}

class ProductCheckerInitialState extends ProductCheckerState {
  @override
  List<Object?> get props => [];
}

class ProductCheckerErrorState extends ProductCheckerState {
  final String message;
  final List<Platform>? platforms;
  final Platform? platform;
  const ProductCheckerErrorState(
      {required this.message, this.platforms, this.platform});
  @override
  List<Object?> get props => [message, platforms, platform];
}
