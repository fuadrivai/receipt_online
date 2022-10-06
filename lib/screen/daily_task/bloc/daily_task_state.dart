part of 'daily_task_bloc.dart';

class DailyTaskState extends Equatable {
  final DailyTask? dailyTask;
  final DailyTask? tempDailyTask;
  final Receipt? receipt;
  final bool isLoading;

  const DailyTaskState({
    this.receipt,
    this.dailyTask,
    this.isLoading = false,
    this.tempDailyTask,
  });

  DailyTaskState copyWith({dailyTask, tempDailyTask, isLoading, receipt}) {
    return DailyTaskState(
      dailyTask: dailyTask ?? this.dailyTask,
      receipt: receipt ?? this.receipt,
      tempDailyTask: tempDailyTask ?? this.tempDailyTask,
      isLoading: isLoading ?? this.isLoading ?? false,
    );
  }

  @override
  List<Object?> get props => [dailyTask, isLoading, receipt, tempDailyTask];
}
