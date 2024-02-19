part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class OnGetReportDetail extends ReportEvent {
  final ReportDetail detail;
  const OnGetReportDetail(this.detail);
}
