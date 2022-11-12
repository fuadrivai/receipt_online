part of 'by_id_bloc.dart';

abstract class ByIdState extends Equatable {
  const ByIdState();
}

class ByIdDetailError extends ByIdState {
  final String message;
  const ByIdDetailError(this.message);
  @override
  List<Object?> get props => [];
}

class ByIdDetailLoading extends ByIdState {
  @override
  List<Object?> get props => [];
}

class ByIdDetailStandBy extends ByIdState {
  @override
  List<Object?> get props => [];
}

class ByIdOrderDetail extends ByIdState {
  final TransactionOnline listOrder;
  const ByIdOrderDetail(this.listOrder);
  @override
  List<Object?> get props => [listOrder];
}
