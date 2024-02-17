import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(const ReportState()) {
    on<ReportEvent>((event, emit) {});
  }
}
