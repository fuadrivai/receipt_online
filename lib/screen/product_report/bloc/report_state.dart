part of 'report_bloc.dart';

final class ReportState extends Equatable {
  const ReportState({this.details});
  final List<Report>? details;

  ReportState copyWith({List<Report>? details}) {
    return ReportState(details: this.details ?? details);
  }

  @override
  List<Object?> get props => [details];
}
