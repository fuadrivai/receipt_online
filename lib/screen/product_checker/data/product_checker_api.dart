import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/service/api.dart';

class ProductCheckerApi {
  static Future<List<Platform>> getPlatforms() async {
    final client = await Api.restClient();
    var data = client.getPlatform();
    return data;
  }
}
