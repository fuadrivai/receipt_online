part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<DailyTask>? dailyTasks;
  final bool isLoading;

  const HomeState({
    this.dailyTasks,
    this.isLoading = false,
  });

  HomeState copyWith({
    dailyTasks,
    isLoading,
  }) {
    return HomeState(
      dailyTasks: dailyTasks,
      isLoading: isLoading ?? this.isLoading ?? false,
    );
  }

  @override
  List<Object?> get props => [
        dailyTasks,
        isLoading,
      ];
}
