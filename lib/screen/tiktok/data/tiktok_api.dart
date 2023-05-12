import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/service/api.dart';

class TiktokApi {
  static Future<List<TransactionOnline>> getorders() async {
    final client = await Api.restClient();
    var data = client.getTiktokOrders();
    return data;
  }

  static Future<List<TransactionOnline>> getorder(String orderSn) async {
    final client = await Api.restClient();
    var data = client.getTiktokOrder(orderSn);
    return data;
  }
}
