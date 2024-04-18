part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class DataState extends HomeState {
  final List<DailyTask>? dailyTasks;
  final DailyTask? dailyTask;
  final List<Expedition>? expeditions;
  final List<Platform>? platforms;
  final ExpiredToken? expired;
  const DataState(
      {this.dailyTasks,
      this.expired,
      this.dailyTask,
      this.expeditions,
      this.platforms});
  @override
  List<Object?> get props =>
      [expired, dailyTasks, dailyTask, expeditions, platforms];
}

class HomeLoadingState extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeErrorState extends HomeState {
  final String error;
  const HomeErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
