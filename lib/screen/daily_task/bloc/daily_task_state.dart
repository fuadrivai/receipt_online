part of 'daily_task_bloc.dart';

class DailyTaskState extends Equatable {
  final DailyTask? dailyTask;
  final DailyTask? tempDailyTask;
  final Receipt? receipt;
  final bool isLoading;
  final bool isError;

  const DailyTaskState({
    this.receipt,
    this.dailyTask,
    this.isLoading = true,
    this.tempDailyTask,
    this.isError = false,
  });

  DailyTaskState copyWith(
      {dailyTask, tempDailyTask, isLoading, receipt, isError}) {
    return DailyTaskState(
      dailyTask: dailyTask ?? this.dailyTask,
      receipt: receipt ?? this.receipt,
      tempDailyTask: tempDailyTask ?? this.tempDailyTask,
      isLoading: isLoading ?? this.isLoading ?? false,
      isError: isError ?? this.isError ?? false,
    );
  }

  @override
  List<Object?> get props => [
        dailyTask,
        isLoading,
        receipt,
        tempDailyTask,
        isError,
      ];
}
