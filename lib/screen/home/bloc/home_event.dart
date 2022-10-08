part of 'home_bloc.dart';

abstract class HomeEvent {
  HomeEvent();
}

class GetCurrentDailyTask extends HomeEvent {
  GetCurrentDailyTask();
}

class OnChangeTotal extends HomeEvent {
  int total;
  OnChangeTotal(this.total);
}

class DailyTaskOnSave extends HomeEvent {
  DailyTask dailyTask;
  DailyTaskOnSave(this.dailyTask);
}
