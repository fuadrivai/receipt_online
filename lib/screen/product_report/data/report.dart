import 'package:receipt_online_shop/screen/product_report/data/report_detail.dart';
import 'package:receipt_online_shop/screen/product_report/data/report_total.dart';

class Report {
  String? periode;
  int? amount;
  List<ReportDetail>? details;
  List<ReportTotal>? totals;

  Report({
    this.amount,
    this.details,
    this.periode,
    this.totals,
  });
}
