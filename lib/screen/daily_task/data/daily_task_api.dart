import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/model/receipt.dart';
import 'package:receipt_online_shop/service/api.dart';

class DailyTaskApi {
  static Future<List<DailyTask>> findCurrentDailyTask() async {
    final client = await Api.restClient();
    var data = client.findCurrentDailyTask();
    return data;
  }

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

  static Future posReceipt(int id, Receipt receipt) async {
    final client = await Api.restClient();
    var data = client.dailyTaskPostReceipt(id, receipt);
    return data;
  }
}
