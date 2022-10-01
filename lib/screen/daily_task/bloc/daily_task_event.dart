part of 'daily_task_bloc.dart';

abstract class DailyTaskEvent {
  DailyTaskEvent();
}

class GetDailyTask extends DailyTaskEvent {
  int id;
  GetDailyTask(this.id);
}
