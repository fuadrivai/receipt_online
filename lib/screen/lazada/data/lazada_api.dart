import 'package:receipt_online_shop/model/lazada/full_order.dart';
import 'package:receipt_online_shop/model/lazada/order.dart';
import 'package:receipt_online_shop/model/lazada/order_rts.dart';
import 'package:receipt_online_shop/service/api.dart';

class LazadaApi {
  static Future<FullOrder> getPackedOrder(String sorting) async {
    final client = await Api.restClient();
    var data = client.getPackedOrder(sorting);
    return data;
  }

  static Future<FullOrder> getRtsOrder(String sorting) async {
    final client = await Api.restClient();
    var data = client.getRtsOrder(sorting);
    return data;
  }

  static Future<FullOrder> getPendingOrder(String sorting) async {
    final client = await Api.restClient();
    var data = client.getPendingOrder(sorting);
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
