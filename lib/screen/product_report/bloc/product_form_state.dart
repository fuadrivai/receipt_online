part of 'product_form_bloc.dart';

final class ProductFormState extends Equatable {
  final bool? isLoading, isError;
  final String? errorMessage;
  final ReportDetail? detail;
  const ProductFormState({
    this.isLoading,
    this.isError,
    this.errorMessage,
    this.detail,
  });

  ProductFormState copyWith({
    bool? isLoading,
    isError,
    String? errorMessage,
    ReportDetail? detail,
  }) {
    return ProductFormState(
      errorMessage: errorMessage ?? this.errorMessage,
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      detail: detail ?? this.detail,
    );
  }

  @override
  List<Object?> get props => [errorMessage, isLoading, isError, detail];
}
