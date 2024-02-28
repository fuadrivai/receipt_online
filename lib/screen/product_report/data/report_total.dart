// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:pdf/widgets.dart' as pw;
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/library/string_uppercase.dart';
import 'package:receipt_online_shop/screen/product/data/product.dart';

class ReportTotal {
  String? age;
  List<Sizes>? sizes;

  ReportTotal({this.age, this.sizes});

  ReportTotal.fromJson(Map<String, dynamic> json) {
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

  pw.Widget getIndex2(int row, int index) {
    switch (index) {
      case 0:
        return pw.Text((row + 1).toString());
      case 1:
        return pw.Text(age ?? "");
      case 2:
        return pw.Column(
          children: (sizes ?? []).map((e) {
            return pw.Text(e.size ?? "");
          }).toList(),
        );
      case 3:
        return pw.Column(
          children: (sizes ?? []).map((e) {
            return pw.Text(((e.tastes ?? [])[0].qty ?? 0).toString());
          }).toList(),
        );
      case 4:
        return pw.Column(
          children: (sizes ?? []).map((e) {
            return pw.Text(((e.tastes ?? [])[1].qty ?? 0).toString());
          }).toList(),
        );
      case 5:
        return pw.Column(
          children: (sizes ?? []).map((e) {
            return pw.Text((e.totalCarton ?? 0).toString());
          }).toList(),
        );
      case 6:
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: (sizes ?? []).map((e) {
            return pw.Text(Common.oCcy.format((e.totalPrice ?? 0)));
          }).toList(),
        );
    }
    return pw.SizedBox.shrink();
  }

  pw.Widget getEmptyIndex(int row, int index, int start) {
    Sizes _sizes = (sizes ?? [])[0];
    Tastes _taste = (_sizes.tastes ?? [])[0];
    switch (index) {
      case 0:
        return pw.Text((row + start + 1).toString());
      case 1:
        return pw.Text((_taste.product?.name ?? "").firstUpperCase());
      case 2:
        return pw.Text(Common.oCcy.format(_taste.qty ?? 0));
      case 3:
        return pw.Text(Common.oCcy.format(_sizes.totalCarton ?? 0));
      case 4:
        return pw.Text(Common.oCcy.format(_sizes.totalPrice ?? 0));
    }
    return pw.SizedBox.shrink();
  }
}

class Sizes {
  String? size;
  int? totalQty;
  int? totalPrice;
  int? totalCarton;
  List<Tastes>? tastes;

  Sizes({
    this.size,
    this.totalQty,
    this.tastes,
    this.totalPrice,
    this.totalCarton,
  });

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
