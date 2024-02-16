import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_report_event.dart';
part 'product_report_state.dart';

class ProductReportBloc extends Bloc<ProductReportEvent, ProductReportState> {
  ProductReportBloc() : super(const ProductReportState()) {
    on<ProductReportEvent>((event, emit) {});
  }
}
