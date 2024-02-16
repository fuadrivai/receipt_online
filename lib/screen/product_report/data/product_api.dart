import 'package:receipt_online_shop/screen/product_report/data/product.dart';
import 'package:receipt_online_shop/service/api.dart';

class ProductApi {
  static Future<List<Product>> get() async {
    final client = await Api.restClient();
    var data = client.getProducts();
    return data;
  }

  static Future<Product> getByBarcode(String barcode) async {
    final client = await Api.restClient();
    var data = client.getProductByBarcode(barcode);
    return data;
  }
}
