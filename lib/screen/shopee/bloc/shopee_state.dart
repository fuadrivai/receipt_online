part of 'shopee_bloc.dart';

abstract class ShopeeDetailState extends Equatable {
  const ShopeeDetailState();
}

class ShopeeDetailError extends ShopeeDetailState {
  final String message;
  const ShopeeDetailError(this.message);
  @override
  List<Object?> get props => [];
}

class ShopeeDetailLoading extends ShopeeDetailState {
  @override
  List<Object?> get props => [];
}

class ShopeeDetailStandBy extends ShopeeDetailState {
  @override
  List<Object?> get props => [];
}

class ShopeeOrderDetail extends ShopeeDetailState {
  final List<ShopeeOrder> listOrder;
  const ShopeeOrderDetail(this.listOrder);
  @override
  List<Object?> get props => [listOrder];
}
