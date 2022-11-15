part of 'product_checker_bloc.dart';

abstract class ProductCheckerState extends Equatable {
  const ProductCheckerState();
}

class ProductCheckerStandByState extends ProductCheckerState {
  final List<Platform>? platforms;
  const ProductCheckerStandByState({this.platforms});
  @override
  List<Object?> get props => [platforms];
}

class ProductCheckerDataState extends ProductCheckerState {
  final List<Platform>? platforms;
  final List<TransactionOnline>? data;
  const ProductCheckerDataState({this.platforms, this.data});

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
  const ProductCheckerErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
