import 'package:receipt_online_shop/model/serverside.dart';
import 'package:receipt_online_shop/screen/product/data/product.dart';
import 'package:receipt_online_shop/service/api.dart';

class ProductApi {
  static Future<ServerSide> get({Map<String, dynamic>? params}) async {
    final client = await Api.restClient(params: params);
    var data = client.getProducts();
    return data;
  }

  static Future<Product> getByBarcode(String barcode) async {
    final client = await Api.restClient();
    var data = client.getProductByBarcode(barcode);
    return data;
  }
}
