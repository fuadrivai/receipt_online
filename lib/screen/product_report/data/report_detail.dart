import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/screen/product/data/product.dart';

class ReportDetail {
  Product? product;
  String? taste, age, size;
  int? qty;
  int? qtyCarton;
  int? totalCarton;
  double? subTotal;
  bool? isChecked;
  ReportDetail({
    this.qty = 0,
    this.qtyCarton = 0,
    this.totalCarton = 0,
    this.subTotal = 0,
    this.taste,
    this.age,
    this.size,
    this.product,
    this.isChecked = false,
  });

  String getIndex(int row, int index) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return product?.name ?? "--";
      case 2:
        return Common.oCcy.format(qty ?? 0);
      case 3:
        return Common.oCcy.format(((qty ?? 0) / (qtyCarton ?? 0)).floor());
      case 4:
        return Common.oCcy.format(subTotal ?? 0);
    }
    return '';
  }
}
