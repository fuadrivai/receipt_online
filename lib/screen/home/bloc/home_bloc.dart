import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/screen/daily_task/data/daily_task_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeEvent>((event, emit) async {
      if (event is GetCurrentDailyTask) {
        emit(const HomeState(isLoading: true));
        HomeState homeState = await _getExpedition(event, emit);
        emit(homeState);
      }
    });
  }

  Future<HomeState> _getExpedition(
      GetCurrentDailyTask event, Emitter<HomeState> emit) async {
    try {
      List<DailyTask> dailyTasks = await DailyTaskApi.findCurrentDailyTask();
      emit(HomeState(dailyTasks: dailyTasks, isLoading: false));
      return state.copyWith(
        dailyTasks: dailyTasks,
        isLoading: false,
      );
    } catch (e) {
      emit(const HomeState(isLoading: false));
      return state.copyWith(isLoading: false);
    }
  }
}
