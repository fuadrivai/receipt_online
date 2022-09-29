part of 'home_bloc.dart';

abstract class HomeEvent {
  HomeEvent();
}

class GetCurrentDailyTask extends HomeEvent {
  GetCurrentDailyTask();
}
