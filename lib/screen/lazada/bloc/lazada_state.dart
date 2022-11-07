part of 'lazada_bloc.dart';

abstract class LazadaState extends Equatable {
  const LazadaState();
}

class LazadaErrorState extends LazadaState {
  @override
  List<Object?> get props => [];
}

class LazadaLoadingState extends LazadaState {
  @override
  List<Object?> get props => [];
}

class LazadaOnChangeState extends LazadaState {
  final int tab;
  final String sorting;
  const LazadaOnChangeState(this.sorting, this.tab);
  @override
  List<Object?> get props => [sorting, tab];
}

class LazadaFullOrderState extends LazadaState {
  final List<TransactionOnline> transactions;
  final List<TransactionOnline> tempTransaction;
  final List<LogisticChannel> listLogisticChannel;
  final LazadaCount count;
  const LazadaFullOrderState(this.transactions, this.count,
      this.tempTransaction, this.listLogisticChannel);
  @override
  List<Object?> get props =>
      [transactions, count, tempTransaction, listLogisticChannel];
}
