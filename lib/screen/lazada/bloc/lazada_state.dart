part of 'lazada_bloc.dart';

class LazadaState extends Equatable {
  final FullOrder? fullOrder;
  final Order? order;
  final bool isLoading;

  const LazadaState({
    this.fullOrder,
    this.order,
    this.isLoading = false,
  });

  LazadaState copyWith({fullOrder, tempDailyTask, isLoading, order}) {
    return LazadaState(
      fullOrder: fullOrder ?? this.fullOrder,
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading ?? false,
    );
  }

  @override
  List<Object?> get props => [order, isLoading, fullOrder];
}
