import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/model/receipt_detail_SKU.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';

class Receipt {
  String? number;
  int? id;
  String? orderId;
  String? image;
  String? createdAt;
  String? updatedAt;
  Platform? platform;
  Expedition? expedition;
  List<ReceiptDetailSku>? skus;

  Receipt({
    this.number,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.orderId,
    this.platform,
    this.expedition,
    this.image,
    this.skus,
  });

  Receipt.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    id = json['id'];
    orderId = json['order_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    platform =
        json['platform'] != null ? Platform.fromJson(json['platform']) : null;
    expedition = json['expedition'] != null
        ? Expedition.fromJson(json['expedition'])
        : null;

    if (json['skus'] != null) {
      skus = <ReceiptDetailSku>[];
      json['skus'].forEach((v) {
        skus!.add(ReceiptDetailSku.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['number'] = number;
    data['id'] = id;
    data['order_id'] = orderId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image'] = image;
    if (platform != null) {
      data['platform'] = platform!.toJson();
    }
    if (expedition != null) {
      data['expedition'] = expedition!.toJson();
    }
    if (skus != null) {
      data['skus'] = skus!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  factory Receipt.clone(Receipt receipt) {
    return Receipt(
      number: receipt.number,
      id: receipt.id,
      orderId: receipt.orderId,
      createdAt: receipt.createdAt,
      updatedAt: receipt.updatedAt,
      platform: receipt.platform,
      image: receipt.image,
      expedition: receipt.expedition,
      skus: receipt.skus,
    );
  }
}
