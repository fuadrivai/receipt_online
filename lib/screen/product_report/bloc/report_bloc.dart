import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/screen/product_report/data/report.dart';
import 'package:receipt_online_shop/screen/product_report/data/report_detail.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(const ReportState()) {
    on<OnGetReportDetail>(_onGetReportDetail);
  }

  void _onGetReportDetail(OnGetReportDetail event, Emitter<ReportState> emit) {
    List<Report> details = state.details ?? [];
    List<Report> filter =
        details.where((e) => e.age == event.detail.age).toList();
    if (filter.isEmpty) {
      details.add(reportMapping(event.detail));
    } else {
      for (var f in filter) {
        List<Sizes> sizes =
            (f.sizes ?? []).where((s) => s.size == event.detail.size).toList();
        if (sizes.isEmpty) {
          (f.sizes ?? []).add(
            Sizes(
              size: event.detail.size,
              totalQty: event.detail.qty,
              tastes: [
                Tastes(
                  price: event.detail.product?.price ?? 0,
                  qty: event.detail.qty,
                  qtyCarton: event.detail.qtyCarton,
                  taste: event.detail.taste,
                )
              ],
            ),
          );
        } else {
          for (var s in sizes) {
            List<Tastes> tastes = (s.tastes ?? [])
                .where((t) => t.taste == event.detail.taste)
                .toList();
            if (tastes.isEmpty) {
              (s.tastes ?? []).add(Tastes(
                price: event.detail.product?.price ?? 0,
                qty: event.detail.qty,
                qtyCarton: event.detail.qtyCarton,
                taste: event.detail.taste,
              ));
            } else {
              for (var t in tastes) {
                t.qty = event.detail.qty;
                t.qtyCarton = event.detail.qtyCarton;
              }
            }
            s.totalQty = 0;
            for (var st in tastes) {
              s.totalQty = (s.totalQty ?? 0) + (st.qty ?? 0);
            }
          }
        }
      }
    }
    emit(state.copyWith(details: details));
  }

  reportMapping(ReportDetail detail) {
    return Report(
      age: detail.age,
      sizes: [
        Sizes(
          size: detail.size,
          totalQty: detail.qty,
          tastes: [
            Tastes(
              price: detail.product?.price ?? 0,
              qty: detail.qty,
              qtyCarton: detail.qtyCarton,
              taste: detail.taste,
            )
          ],
        ),
      ],
    );
  }
}
