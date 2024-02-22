import 'package:receipt_online_shop/screen/product/data/product.dart';

class ReportDetail {
  Product? product;
  String? taste, age, size;
  int? qty;
  int? qtyCarton;
  int? totalCarton;
  double? subTotal;
  ReportDetail({
    this.qty = 0,
    this.qtyCarton = 0,
    this.totalCarton = 0,
    this.subTotal,
    this.taste,
    this.age,
    this.size,
    this.product,
  });
}
