import 'package:receipt_online_shop/model/expired_token.dart';
import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/service/api.dart';

class HomeApi {
  static Future<List<Platform>> getPlatforms() async {
    final client = await Api.restClient();
    var data = client.getPlatforms();
    return data;
  }

  static Future<ExpiredToken> authDate() async {
    final client = await Api.restClient();
    var data = client.lazadaAuthDate();
    return data;
  }
}
