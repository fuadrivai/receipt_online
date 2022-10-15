import 'package:receipt_online_shop/model/lazada/full_order.dart';
import 'package:receipt_online_shop/model/lazada/order.dart';
import 'package:receipt_online_shop/service/api.dart';

class LazadaApi {
  static Future<FullOrder> getOrders() async {
    final client = await Api.restClient();
    var data = client.getOrders();
    return data;
  }

  static Future<Order> getOrder(int orderId) async {
    final client = await Api.restClient();
    var data = client.getOrder(orderId);
    return data;
  }
}
