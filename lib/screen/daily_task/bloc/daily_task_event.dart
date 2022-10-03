part of 'daily_task_bloc.dart';

abstract class DailyTaskEvent {
  DailyTaskEvent();
}

class GetDailyTask extends DailyTaskEvent {
  int id;
  GetDailyTask(this.id);
}

class PostReceipt extends DailyTaskEvent {
  int id;
  String platform;
  String barcode;
  PostReceipt(this.id, this.platform, this.barcode);
}
