part of 'daily_task_bloc.dart';

class DailyTaskState extends Equatable {
  final DailyTask? dailyTask;
  final Receipt? receipt;
  final bool isLoading;

  const DailyTaskState({
    this.receipt,
    this.dailyTask,
    this.isLoading = false,
  });

  DailyTaskState copyWith({dailyTask, isLoading, receipt}) {
    return DailyTaskState(
      dailyTask: dailyTask ?? this.dailyTask,
      receipt: receipt ?? this.receipt,
      isLoading: isLoading ?? this.isLoading ?? false,
    );
  }

  @override
  List<Object?> get props => [dailyTask, isLoading, receipt];
}
