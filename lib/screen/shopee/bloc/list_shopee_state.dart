part of 'list_shopee_bloc.dart';

abstract class ListShopeeState extends Equatable {
  const ListShopeeState();
}

class ListShopeeError extends ListShopeeState {
  final String message;
  const ListShopeeError(this.message);
  @override
  List<Object?> get props => [];
}

class ListShopeeLoading extends ListShopeeState {
  @override
  List<Object?> get props => [];
}

class ListShopeeData extends ListShopeeState {
  final List<ShopeeOrder> listOrder;
  final List<LogisticChannel> listLogisticChannel;
  const ListShopeeData(this.listOrder, this.listLogisticChannel);
  @override
  List<Object?> get props => [listOrder, listLogisticChannel];
}
