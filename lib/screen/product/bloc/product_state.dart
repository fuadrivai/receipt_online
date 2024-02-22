part of 'product_bloc.dart';

final class ProductState extends Equatable {
  const ProductState({
    this.isLoading,
    this.serverSide,
    this.products,
    this.loadMore,
  });
  final bool? isLoading, loadMore;
  final ServerSide? serverSide;
  final List<Product>? products;

  ProductState copyWith({
    bool? isLoading,
    loadMore,
    ServerSide? serverSide,
    List<Product>? products,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      loadMore: loadMore ?? this.loadMore,
      serverSide: serverSide ?? this.serverSide,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [isLoading, products, serverSide, loadMore];
}
