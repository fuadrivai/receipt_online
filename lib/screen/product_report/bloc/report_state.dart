part of 'report_bloc.dart';

final class ReportState extends Equatable {
  const ReportState({
    this.report,
    this.isError,
    this.isSuccess,
    this.isLoading,
    this.errorMessage,
  });
  final Report? report;
  final bool? isError, isSuccess, isLoading;
  final String? errorMessage;

  ReportState copyWith({
    Report? report,
    bool? isError,
    bool? isSuccess,
    String? errorMessage,
    bool? isLoading,
  }) {
    return ReportState(
      report: this.report ?? report,
      isError: this.isError ?? isError,
      isSuccess: this.isSuccess ?? isSuccess,
      isLoading: this.isLoading ?? isLoading,
      errorMessage: this.errorMessage ?? errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        report,
        isSuccess,
        isError,
        errorMessage,
        isLoading,
      ];
}
