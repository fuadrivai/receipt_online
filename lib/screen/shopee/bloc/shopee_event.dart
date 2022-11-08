part of 'shopee_bloc.dart';

abstract class ShopeeDetailEvent extends Equatable {
  const ShopeeDetailEvent();
}

class GetShopeeOrder extends ShopeeDetailEvent {
  final String orderSn;
  const GetShopeeOrder(this.orderSn);

  @override
  List<Object?> get props => [orderSn];
}

class ShopeeStandBy extends ShopeeDetailEvent {
  @override
  List<Object?> get props => [];
}

class ShopeeRtsEvent extends ShopeeDetailEvent {
  final String orderSn;
  const ShopeeRtsEvent(this.orderSn);
  @override
  List<Object?> get props => [orderSn];
}
