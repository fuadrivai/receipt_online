part of 'jd_id_bloc.dart';

abstract class JdIdState extends Equatable {
  const JdIdState();
}

class JdIdDetailError extends JdIdState {
  final String message;
  const JdIdDetailError(this.message);
  @override
  List<Object?> get props => [];
}

class JdIdDetailLoading extends JdIdState {
  @override
  List<Object?> get props => [];
}

class JdIdDetailStandBy extends JdIdState {
  @override
  List<Object?> get props => [];
}

class JdIdOrderDetail extends JdIdState {
  final TransactionOnline listOrder;
  const JdIdOrderDetail(this.listOrder);
  @override
  List<Object?> get props => [listOrder];
}
