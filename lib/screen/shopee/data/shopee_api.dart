import 'package:receipt_online_shop/model/shopee/shopee_order.dart';
import 'package:receipt_online_shop/service/api.dart';

class ShopeeApi {
  static Future<List<ShopeeOrder>> getShopeeOrderByNo(String orderSn) async {
    final client = await Api.restClient();
    var data = client.getShopeeOrderByNo(orderSn);
    return data;
  }

  static Future<List<ShopeeOrder>> getOrders() async {
    final client = await Api.restClient();
    var data = client.getShopeeOrders();
    return data;
  }
}
