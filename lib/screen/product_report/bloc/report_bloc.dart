import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/screen/product_report/data/report.dart';
import 'package:receipt_online_shop/screen/product_report/data/report_total.dart';
import 'package:receipt_online_shop/screen/product_report/data/report_detail.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(const ReportState()) {
    on<OnGetReportDetail>(_onGetReportDetail);
    on<OnPushReportDetail>(_onPushReportDetail);
    on<OnMapReportDetail>(_onMapReportDetail);
    on<OnMapReport>(_onMapReport);
  }

  void _onMapReport(OnMapReport event, Emitter<ReportState> emit) {
    Report report = state.report ?? Report();
    List<ReportTotal> totals = report.totals ?? [];
    List<ReportDetail> details = report.details ?? [];
    report.periode = event.periode;

    for (var detail in details) {
      if (totals.isEmpty) {
        totals.add(reportMapping(detail));
      } else if (detail.age == null) {
        totals.add(reportMapping(detail));
      } else {
        List<ReportTotal> isTotal =
            totals.where((e) => e.age == detail.age).toList();
        if (isTotal.isNotEmpty) {
          for (var total in isTotal) {
            List<Sizes> sizes = (total.sizes ?? [])
                .where((s) => s.size == detail.size)
                .toList();
            if (sizes.isEmpty) {
              (total.sizes ?? []).add(
                Sizes(
                  size: detail.size,
                  totalQty: detail.qty,
                  tastes: [
                    Tastes(
                      price: detail.product?.price ?? 0,
                      qty: detail.qty,
                      qtyCarton: detail.qtyCarton,
                      taste: detail.taste,
                      product: detail.product,
                    )
                  ],
                ),
              );
            } else {
              int totalQty = 0;
              int totalPrice = 0;
              int qtyCarton = 0;
              for (var s in sizes) {
                List<Tastes> tastes = (s.tastes ?? [])
                    .where((t) => t.taste == detail.taste)
                    .toList();
                if (tastes.isEmpty) {
                  (s.tastes ?? []).add(Tastes(
                    price: detail.product?.price ?? 0,
                    qty: detail.qty,
                    qtyCarton: detail.qtyCarton,
                    taste: detail.taste,
                    product: detail.product,
                  ));
                } else {
                  for (var t in tastes) {
                    t.qty = detail.qty;
                    t.qtyCarton = detail.qtyCarton;
                  }
                }
                for (Tastes st in s.tastes ?? []) {
                  qtyCarton = st.qtyCarton ?? 0;
                  totalQty = totalQty + (st.qty ?? 0);
                  totalPrice = totalPrice + ((st.qty ?? 0) * (st.price ?? 0));
                }
                s.totalQty = totalQty;
                s.totalCarton = (totalQty / qtyCarton).floor();
                s.totalPrice = totalPrice;
              }
            }
          }
        } else {
          totals.add(reportMapping(detail));
        }
      }
    }
    report.totals = totals;

    emit(state.copyWith(
      report: report,
    ));
  }

  void _onMapReportDetail(OnMapReportDetail event, Emitter<ReportState> emit) {
    Report report = state.report ?? Report();
    List<ReportDetail> filter = (report.details ?? [])
        .where((e) => e.product?.barcode == event.detail.product?.barcode)
        .toList();

    if (filter.isNotEmpty) {
      for (var e in filter) {
        e = event.detail;
        e.isChecked = true;
      }
    }

    report.amount = 0;
    for (var d in (report.details ?? [])) {
      report.amount =
          ((d.qty ?? 0) * (d.product?.price ?? 0) ?? 0) + (report.amount);
    }
    emit(state.copyWith(report: report));
  }

  void _onPushReportDetail(
      OnPushReportDetail event, Emitter<ReportState> emit) {
    Report report = state.report ?? Report();
    report.details = event.details;
    report.amount = 0;
    for (var d in (report.details ?? [])) {
      report.amount =
          ((d.qty ?? 0) * (d.product?.price ?? 0) ?? 0) + (report.amount);
    }
    emit(state.copyWith(report: report));
  }

  void _onGetReportDetail(OnGetReportDetail event, Emitter<ReportState> emit) {
    emit(state.copyWith(isError: false));
    Report report = state.report ?? Report();

    List<ReportDetail> details = report.details ?? [];
    bool isError = false;
    String errorMessage = "";

    if (details.isEmpty) {
      details.add(event.detail);
    } else {
      bool isAny = details
          .any((s) => s.product?.barcode == event.detail.product?.barcode);
      if (!isAny) {
        bool isExist = details.any((e) =>
            (e.age == event.detail.age) &&
            (e.size == event.detail.size) &&
            (e.taste == event.detail.taste));
        if (isExist) {
          isError = true;
          errorMessage = "Usia, Rasa dan Kemasan yang sama sudah di input";
        } else {
          details.add(event.detail);
        }
      } else {
        for (var i = 0; i < details.length; i++) {
          var e = details[i];
          if (e.product?.barcode == event.detail.product?.barcode) {
            e = event.detail;
          }
        }
      }
    }
    List<ReportTotal> totals = [];
    for (var detail in details) {
      if (totals.isEmpty) {
        totals.add(reportMapping(detail));
      } else {
        bool isTotal = totals.any((e) => e.age == detail.age);
        if (isTotal) {
          for (var total in totals) {
            List<Sizes> sizes = (total.sizes ?? [])
                .where((s) => s.size == detail.size)
                .toList();
            if (sizes.isEmpty) {
              (total.sizes ?? []).add(
                Sizes(
                  size: detail.size,
                  totalQty: detail.qty,
                  tastes: [
                    Tastes(
                      price: detail.product?.price ?? 0,
                      qty: detail.qty,
                      qtyCarton: detail.qtyCarton,
                      taste: detail.taste,
                      product: detail.product,
                    )
                  ],
                ),
              );
            } else {
              int totalQty = 0;
              int totalPrice = 0;
              int qtyCarton = 0;
              for (var s in sizes) {
                List<Tastes> tastes = (s.tastes ?? [])
                    .where((t) => t.taste == detail.taste)
                    .toList();
                if (tastes.isEmpty) {
                  (s.tastes ?? []).add(Tastes(
                    price: detail.product?.price ?? 0,
                    qty: detail.qty,
                    qtyCarton: detail.qtyCarton,
                    taste: detail.taste,
                    product: detail.product,
                  ));
                } else {
                  for (var t in tastes) {
                    t.qty = detail.qty;
                    t.qtyCarton = detail.qtyCarton;
                  }
                }
                for (Tastes st in s.tastes ?? []) {
                  qtyCarton = st.qtyCarton ?? 0;
                  totalQty = totalQty + (st.qty ?? 0);
                  totalPrice = totalPrice + ((st.qty ?? 0) * (st.price ?? 0));
                }
                s.totalQty = totalQty;
                s.totalCarton = (totalQty / qtyCarton).floor();
                s.totalPrice = totalPrice;
              }
            }
          }
        } else {
          totals.add(reportMapping(detail));
        }
      }
    }
    report.totals = totals;

    report.details = details;
    emit(state.copyWith(
      report: report,
      isError: isError,
      errorMessage: errorMessage,
    ));
  }

  reportMapping(ReportDetail detail) {
    return ReportTotal(
      age: detail.age,
      sizes: [
        Sizes(
          size: detail.size,
          totalQty: detail.qty,
          totalCarton: ((detail.qty ?? 0) / (detail.qtyCarton ?? 0)).floor(),
          totalPrice: (detail.product?.price ?? 0) * (detail.qty ?? 0),
          tastes: [
            Tastes(
              price: detail.product?.price ?? 0,
              qty: detail.qty,
              qtyCarton: detail.qtyCarton,
              taste: detail.taste,
              product: detail.product,
            )
          ],
        ),
      ],
    );
  }
}
