import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/service/api.dart';

class JdIdApi {
  static Future<TransactionOnline> getJdIdOrderByNo(String orderSn) async {
    final client = await Api.restClient();
    var data = client.getJdIdOrderByNo(orderSn);
    return data;
  }
}
