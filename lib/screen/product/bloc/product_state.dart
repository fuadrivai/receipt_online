part of 'product_bloc.dart';

final class ProductState extends Equatable {
  const ProductState({
    this.isLoading,
    this.serverSide,
    this.products,
    this.loadMore,
    this.details,
  });
  final bool? isLoading, loadMore;
  final ServerSide? serverSide;
  final List<Product>? products;
  final List<ReportDetail>? details;

  ProductState copyWith({
    bool? isLoading,
    loadMore,
    ServerSide? serverSide,
    List<Product>? products,
    List<ReportDetail>? details,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      loadMore: loadMore ?? this.loadMore,
      serverSide: serverSide ?? this.serverSide,
      products: products ?? this.products,
      details: details ?? this.details,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        products,
        serverSide,
        loadMore,
        details,
      ];
}
