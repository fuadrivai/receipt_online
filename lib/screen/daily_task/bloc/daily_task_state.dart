part of 'daily_task_bloc.dart';

class DailyTaskState extends Equatable {
  final DailyTask? dailyTask;
  final bool isLoading;

  const DailyTaskState({
    this.dailyTask,
    this.isLoading = false,
  });

  DailyTaskState copyWith({
    dailyTask,
    isLoading,
  }) {
    return DailyTaskState(
      dailyTask: dailyTask ?? this.dailyTask,
      isLoading: isLoading ?? this.isLoading ?? false,
    );
  }

  @override
  List<Object?> get props => [
        dailyTask,
        isLoading,
      ];
}
