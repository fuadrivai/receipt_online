import 'package:receipt_online_shop/model/lazada/full_order.dart';
import 'package:receipt_online_shop/model/lazada/order.dart';
import 'package:receipt_online_shop/model/lazada/order_rts.dart';
import 'package:receipt_online_shop/service/api.dart';

class LazadaApi {
  static Future<FullOrder> getPackedOrder() async {
    final client = await Api.restClient();
    var data = client.getPackedOrder();
    return data;
  }

  static Future<FullOrder> getRtsOrder() async {
    final client = await Api.restClient();
    var data = client.getRtsOrder();
    return data;
  }

  static Future<FullOrder> getPendingOrder() async {
    final client = await Api.restClient();
    var data = client.getPendingOrder();
    return data;
  }

  static Future<Order> getOrder(int orderId) async {
    final client = await Api.restClient();
    var data = client.getOrder(orderId);
    return data;
  }

  static Future orderRts(OrderRTS orderRTS) async {
    final client = await Api.restClient();
    var data = client.orderRts(orderRTS.trackingNumber,
        orderRTS.shipmentProvider, orderRTS.orderItemIds);
    return data;
  }
}
