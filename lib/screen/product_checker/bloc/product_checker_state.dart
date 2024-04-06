part of 'product_checker_bloc.dart';

final class ProductCheckerState extends Equatable {
  final List<Platform>? platforms;
  final bool? isLoading;
  final bool? isError;
  final List<TransactionOnline>? data;
  final List<List<bool>>? listManual;
  final Platform? platform;
  final String? errorMessage;
  const ProductCheckerState({
    this.platforms,
    this.platform,
    this.errorMessage,
    this.isError,
    this.isLoading = true,
    this.data,
    this.listManual,
  });

  ProductCheckerState copyWith({
    List<Platform>? platforms,
    bool? isLoading,
    bool? isError,
    Platform? platform,
    String? errorMessage,
    List<TransactionOnline>? data,
    List<List<bool>>? listManual,
  }) {
    return ProductCheckerState(
      platforms: platforms ?? this.platforms,
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      platform: platform ?? this.platform,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      listManual: listManual ?? this.listManual,
    );
  }

  @override
  List<Object?> get props => [
        platforms,
        isLoading,
        data,
        platform,
        isError,
        listManual,
        errorMessage,
      ];
}
