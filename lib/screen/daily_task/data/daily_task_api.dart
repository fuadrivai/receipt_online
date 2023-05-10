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

  static Future post(DailyTask dailyTask) async {
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

  static Future deleteReceipt(String number) async {
    final client = await Api.restClient();
    var data = client.deleteReceipt(number);
    return data;
  }

  static Future multipleDailyTask(List<DailyTask> tasks) async {
    final client = await Api.restClient();
    var data = client.postMultipleDailyTask(tasks);
    return data;
  }

  static Future<Receipt> receiptByDailyTaskId(int id) async {
    final client = await Api.restClient();
    var data = client.receiptByDailyTaskId(id);
    return data;
  }
}
