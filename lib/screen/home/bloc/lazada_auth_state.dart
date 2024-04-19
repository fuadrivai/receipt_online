part of 'lazada_auth_bloc.dart';

final class LazadaAuthState extends Equatable {
  final String? link;
  final String? errorMessage;
  final bool loading;
  final bool isError;
  const LazadaAuthState({
    this.link,
    this.loading = false,
    this.errorMessage,
    this.isError = false,
  });

  LazadaAuthState copyWith({
    String? link,
    bool? loading,
    bool? isError,
    String? errorMessage,
  }) {
    return LazadaAuthState(
      link: link ?? this.link,
      loading: loading ?? this.loading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [link, loading, isError, errorMessage];
}
