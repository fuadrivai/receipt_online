import 'package:receipt_online_shop/model/receipt_detail_product.dart';
import 'package:receipt_online_shop/screen/product/data/product.dart';

class ReceiptDetailSku {
  String? sku;
  int? qty;
  Product? gift;
  List<ReceiptDetailProduct>? manuals;

  ReceiptDetailSku({this.sku, this.qty, this.gift, this.manuals});

  ReceiptDetailSku.fromJson(Map<String, dynamic> json) {
    sku = json['sku'];
    qty = json['qty'];
    gift = json['product_gift'] != null
        ? Product.fromJson(json['product_gift'])
        : null;
    if (json['manuals'] != null) {
      manuals = <ReceiptDetailProduct>[];
      json['manuals'].forEach((v) {
        manuals!.add(ReceiptDetailProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sku'] = sku;
    data['qty'] = qty;
    if (gift != null) {
      data['product_gift'] = gift!.toJson();
    }
    if (manuals != null) {
      data['manuals'] = manuals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
