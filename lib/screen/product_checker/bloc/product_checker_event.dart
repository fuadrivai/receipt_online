part of 'product_checker_bloc.dart';

abstract class ProductCheckerEvent extends Equatable {
  const ProductCheckerEvent();
}

class ProductCheckerInitialEvent extends ProductCheckerEvent {
  @override
  List<Object?> get props => [];
}

class ProductCheckerStandByEvent extends ProductCheckerEvent {
  @override
  List<Object?> get props => [];
}

class ProductCheckerLoadingEvent extends ProductCheckerEvent {
  @override
  List<Object?> get props => [];
}

class ProductCheckerOnTabEvent extends ProductCheckerEvent {
  final Platform platform;
  const ProductCheckerOnTabEvent(this.platform);
  @override
  List<Object?> get props => [platform];
}

class OnInputGift extends ProductCheckerEvent {
  final Product product;
  final Items item;
  const OnInputGift(this.product, this.item);
  @override
  List<Object?> get props => [product];
}

class OnInputProduct extends ProductCheckerEvent {
  final Product product;
  final Items item;
  const OnInputProduct(this.product, this.item);
  @override
  List<Object?> get props => [product];
}

class GetOrderEvent extends ProductCheckerEvent {
  final Platform platform;
  final String orderSn;
  const GetOrderEvent(this.platform, this.orderSn);
  @override
  List<Object?> get props => [platform, orderSn];
}

class RtsEvent extends ProductCheckerEvent {
  final Platform platform;
  final TransactionOnline dataOrder;
  const RtsEvent(this.platform, this.dataOrder);
  @override
  List<Object?> get props => [platform, dataOrder];
}

class OnChangeQtyProduct extends ProductCheckerEvent {
  final Items item;
  final String barcode;
  final int qty;
  const OnChangeQtyProduct({
    required this.item,
    required this.barcode,
    required this.qty,
  });
  @override
  List<Object?> get props => [item, barcode, qty];
}

class OnRemoveProduct extends ProductCheckerEvent {
  final Items item;
  final String barcode;
  const OnRemoveProduct(this.item, this.barcode);
  @override
  List<Object?> get props => [item, barcode];
}

class OnRemoveGift extends ProductCheckerEvent {
  final Items item;
  final String barcode;
  const OnRemoveGift(this.item, this.barcode);
  @override
  List<Object?> get props => [item];
}

class CreateOrderEvent extends ProductCheckerEvent {
  final Platform platform;
  final TransactionOnline dataOrder;
  const CreateOrderEvent(this.platform, this.dataOrder);
  @override
  List<Object?> get props => [platform, dataOrder];
}
