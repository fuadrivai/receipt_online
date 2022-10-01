import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/service/api.dart';

class DailyTaskApi {
  static Future<DailyTask> findById(int id) async {
    final client = await Api.restClient();
    var data = client.dailyTaskFindById(id);
    return data;
  }

  static Future<DailyTask> post(DailyTask dailyTask) async {
    final client = await Api.restClient();
    var data = client.postDailyTask(dailyTask);
    return data;
  }

  static Future put(int id, DailyTask dailyTask) async {
    final client = await Api.restClient();
    var data = client.dailyTaskEdit(id, dailyTask);
    return data;
  }
}
