import 'package:receipt_online_shop/screen/product/data/product.dart';

class ReceiptDetailProduct {
  int? qty;
  int? type;
  Product? product;

  ReceiptDetailProduct({this.qty, this.product, this.type});

  ReceiptDetailProduct.fromJson(Map<String, dynamic> json) {
    qty = json['qty'];
    type = json['type'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qty'] = qty;
    data['type'] = type;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}
