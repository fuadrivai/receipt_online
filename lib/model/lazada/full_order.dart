import 'package:receipt_online_shop/model/lazada/order.dart';

class FullOrder {
  int? count;
  int? countTotal;
  List<Order>? orders;

  FullOrder({this.count, this.countTotal, this.orders});

  FullOrder.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    countTotal = json['countTotal'];
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['countTotal'] = countTotal;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
