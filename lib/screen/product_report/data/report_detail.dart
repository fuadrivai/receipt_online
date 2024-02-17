import 'package:receipt_online_shop/screen/product_report/data/product.dart';

class ReportDetail {
  Product? product;
  String? taste, age, size;
  int? qty;
  double? subTotal;
  ReportDetail({
    this.qty,
    this.subTotal,
    this.taste,
    this.age,
    this.size,
    this.product,
  });
}
