import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/service/api.dart';

class ShopeeApi {
  static Future<List<TransactionOnline>> getShopeeOrderByNo(
      String orderSn) async {
    final client = await Api.restClient();
    var data = client.getShopeeOrderByNo(orderSn);
    return data;
  }

  static Future<List<TransactionOnline>> getOrders() async {
    final client = await Api.restClient();
    var data = client.getShopeeOrders();
    return data;
  }

  static Future rts(String orderSn) async {
    final client = await Api.restClient();
    var data = client.shopeeRts(orderSn);
    return data;
  }
}
