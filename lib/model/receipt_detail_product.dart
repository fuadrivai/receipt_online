import 'package:receipt_online_shop/screen/product/data/product.dart';

class ReceiptDetailProduct {
  int? qty;
  Product? product;

  ReceiptDetailProduct({this.qty, this.product});

  ReceiptDetailProduct.fromJson(Map<String, dynamic> json) {
    qty = json['qty'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qty'] = qty;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}
