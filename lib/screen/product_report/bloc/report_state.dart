part of 'report_bloc.dart';

final class ReportState extends Equatable {
  const ReportState({
    this.report,
    this.isError,
    this.isSuccess,
    this.errorMessage,
  });
  final Report? report;
  final bool? isError, isSuccess;
  final String? errorMessage;

  ReportState copyWith(
      {Report? report, bool? isError, bool? isSuccess, String? errorMessage}) {
    return ReportState(
      report: this.report ?? report,
      isError: this.isError ?? isError,
      isSuccess: this.isSuccess ?? isError,
      errorMessage: this.errorMessage ?? errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        report,
        isSuccess,
        isError,
        errorMessage,
      ];
}
