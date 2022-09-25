import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';
import 'package:receipt_online_shop/service/api.dart';

class ExpeditionApi {
  static Future<List<Expedition>> findAll() async {
    final client = await Api.restClient();
    var data = client.findAllExpedition();
    return data;
  }

  static Future<Expedition> findById(int id) async {
    final client = await Api.restClient();
    var data = client.expeditionFindById(id);
    return data;
  }

  static Future<Expedition> post(Expedition expedition) async {
    final client = await Api.restClient();
    var data = client.postExpedition(expedition);
    return data;
  }

  static Future put(String id, Expedition expedition) async {
    final client = await Api.restClient();
    var data = client.expeditionEdit(id, expedition);
    return data;
  }
}
