import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/service/api.dart';

class HomeApi {
  static Future<List<DailyTask>> findCurrentDailyTask() async {
    final client = await Api.restClient();
    var data = client.findCurrentDailyTask();
    return data;
  }
}
