part of 'daily_task_bloc.dart';

abstract class DailyTaskEvent {
  DailyTaskEvent();
}

class GetDailyTask extends DailyTaskEvent {
  int id;
  GetDailyTask(this.id);
}

class SearchReceipt extends DailyTaskEvent {
  String number;
  SearchReceipt(this.number);
}

class RemoveReceipt extends DailyTaskEvent {
  String number;
  RemoveReceipt(this.number);
}

class ExpeditionOnChange extends DailyTaskEvent {
  Expedition expedition;
  ExpeditionOnChange(this.expedition);
}

class TotalPackageOnChange extends DailyTaskEvent {
  int total;
  TotalPackageOnChange(this.total);
}

class PostReceipt extends DailyTaskEvent {
  int id;
  String platform;
  String barcode;
  PostReceipt(this.id, this.platform, this.barcode);
}
