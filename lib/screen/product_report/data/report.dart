import 'package:receipt_online_shop/screen/product_report/data/product.dart';

class Report {
  String? age;
  List<Sizes>? sizes;

  Report({this.age, this.sizes});

  Report.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    if (json['sizes'] != null) {
      sizes = <Sizes>[];
      json['sizes'].forEach((v) {
        sizes!.add(Sizes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['age'] = age;
    if (sizes != null) {
      data['sizes'] = sizes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sizes {
  String? size;
  int? totalQty;
  int? totalPrice;
  List<Tastes>? tastes;

  Sizes({this.size, this.totalQty, this.tastes, this.totalPrice});

  Sizes.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    totalQty = json['totalQty'];
    if (json['tastes'] != null) {
      tastes = <Tastes>[];
      json['tastes'].forEach((v) {
        tastes!.add(Tastes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['size'] = size;
    data['totalQty'] = totalQty;
    if (tastes != null) {
      data['tastes'] = tastes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tastes {
  String? taste;
  Product? product;
  int? qty;
  int? qtyCarton;
  int? price;

  Tastes({this.taste, this.qty, this.qtyCarton, this.price, this.product});

  Tastes.fromJson(Map<String, dynamic> json) {
    taste = json['taste'];
    qty = json['qty'];
    qtyCarton = json['qtyCarton'];
    price = json['price'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taste'] = taste;
    data['qty'] = qty;
    data['qtyCarton'] = qtyCarton;
    data['price'] = price;
    return data;
  }
}
