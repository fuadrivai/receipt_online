import 'package:receipt_online_shop/model/platform.dart';

class Receipt {
  String? number;
  int? id;
  String? orderId;
  String? image;
  String? createdAt;
  String? updatedAt;
  Platform? platform;

  Receipt({
    this.number,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.orderId,
    this.platform,
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
    );
  }
}
