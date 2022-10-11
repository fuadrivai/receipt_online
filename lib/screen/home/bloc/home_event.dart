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

class OnChangeExpedition extends HomeEvent {
  Expedition expedition;
  OnChangeExpedition(this.expedition);
}

class DailyTaskOnSave extends HomeEvent {
  DailyTaskOnSave();
}
