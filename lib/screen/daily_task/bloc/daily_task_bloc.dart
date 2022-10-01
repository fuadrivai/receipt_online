import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/screen/daily_task/data/daily_task_api.dart';

part 'daily_task_event.dart';
part 'daily_task_state.dart';

class DailyTaskBloc extends Bloc<DailyTaskEvent, DailyTaskState> {
  DailyTaskBloc() : super(const DailyTaskState()) {
    on<DailyTaskEvent>((event, emit) async {
      if (event is GetDailyTask) {
        emit(const DailyTaskState(isLoading: true));
        DailyTaskState dailyTaskState = await _getDailyTask(event, emit);
        emit(dailyTaskState);
      }
    });
  }

  Future<DailyTaskState> _getDailyTask(
      GetDailyTask event, Emitter<DailyTaskState> emit) async {
    try {
      int id = event.id;
      DailyTask dailyTask = await DailyTaskApi.findById(id);
      emit(DailyTaskState(dailyTask: dailyTask, isLoading: false));
      return state.copyWith(
        dailyTask: dailyTask,
        isLoading: false,
      );
    } catch (e) {
      emit(const DailyTaskState(isLoading: false));
      return state.copyWith(isLoading: false);
    }
  }
}
