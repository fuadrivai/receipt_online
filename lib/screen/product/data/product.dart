import 'package:receipt_online_shop/screen/product/data/uom.dart';

class Product {
  int? id;
  String? barcode;
  String? name;
  int? convertion;
  int? price;
  String? image;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  UOM? uom;

  Product({
    this.id,
    this.barcode,
    this.name,
    this.convertion,
    this.price,
    this.image,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.uom,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    barcode = json['barcode'];
    name = json['name'];
    convertion = json['convertion'];
    price = json['price'];
    image = json['image'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uom = json['uom'] != null ? UOM.fromJson(json['uom']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['barcode'] = barcode;
    data['name'] = name;
    data['convertion'] = convertion;
    data['price'] = price;
    data['image'] = image;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (uom != null) {
      data['uom'] = uom!.toJson();
    }
    return data;
  }
}
