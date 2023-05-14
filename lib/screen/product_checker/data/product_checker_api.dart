import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/service/api.dart';

class ProductCheckerApi {
  static Future<List<Platform>> getActivePlatform() async {
    final client = await Api.restClient();
    var data = client.getActivePlatform();
    return data;
  }
}
