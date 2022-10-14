import 'package:receipt_online_shop/service/api.dart';

class LazadaApi {
  static Future<dynamic> getOrders() async {
    final client = await Api.restClient();
    var data = client.getOrders();
    return data;
  }
}
