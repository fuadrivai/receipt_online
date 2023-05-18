part of 'tiktok_bloc.dart';

abstract class TiktokState extends Equatable {
  const TiktokState();
}

class TiktokLoadingState extends TiktokState {
  @override
  List<Object?> get props => [];
}

class TiktokErrorState extends TiktokState {
  @override
  List<Object?> get props => [];
}

class TiktokFullOrderState extends TiktokState {
  final List<TransactionOnline> transactions;
  final List<TransactionOnline> tempTransactions;
  const TiktokFullOrderState(this.transactions, this.tempTransactions);
  @override
  List<Object?> get props => [transactions, tempTransactions];
}
