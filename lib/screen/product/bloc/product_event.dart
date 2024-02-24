part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class OnGetProduct extends ProductEvent {
  final Map<String, dynamic> map;
  const OnGetProduct(this.map);
}

class OnLoadMore extends ProductEvent {
  const OnLoadMore();
}

class OnTapProduct extends ProductEvent {
  final bool value;
  final Product product;
  const OnTapProduct(this.value, this.product);
}
