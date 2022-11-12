import 'package:receipt_online_shop/model/lazada/full_order.dart';
import 'package:receipt_online_shop/model/lazada/lazada_count.dart';
import 'package:receipt_online_shop/model/lazada/order_rts.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
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

  static Future<TransactionOnline> getOrder(String orderId) async {
    final client = await Api.restClient();
    var data = client.getOrder(orderId);
    return data;
  }

  static Future<List<TransactionOnline>> getorders(
      String status, String sorting) async {
    final client = await Api.restClient();
    var data = client.lazadaGetFullOrder(status, sorting);
    return data;
  }

  static Future<LazadaCount> getCount() async {
    final client = await Api.restClient();
    var data = client.lazadaGetCount();
    return data;
  }

  static Future orderRts(OrderRTS orderRTS) async {
    final client = await Api.restClient();
    var data = client.orderRts(orderRTS.trackingNumber,
        orderRTS.shipmentProvider, orderRTS.orderItemIds);
    return data;
  }
}
