part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<DailyTask>? dailyTasks;
  final DailyTask? dailyTask;
  final List<Expedition>? expeditions;
  final bool isLoading;

  const HomeState({
    this.dailyTasks,
    this.dailyTask,
    this.expeditions,
    this.isLoading = false,
  });

  HomeState copyWith({
    dailyTasks,
    dailyTask,
    expeditions,
    isLoading,
  }) {
    return HomeState(
      dailyTasks: dailyTasks,
      dailyTask: dailyTask,
      expeditions: expeditions,
      isLoading: isLoading ?? this.isLoading ?? false,
    );
  }

  @override
  List<Object?> get props => [
        dailyTasks,
        dailyTask,
        expeditions,
        isLoading,
      ];
}
