import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/screen/daily_task/data/daily_task_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition_api.dart';

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
      if (event is DailyTaskOnSave) {
        emit(const HomeState(isLoading: true));
        HomeState homeState = await _dailyTaskOnSave(event, emit);
        emit(homeState);
      }
    });
  }

  Future<HomeState> _getExpedition(
      GetCurrentDailyTask event, Emitter<HomeState> emit) async {
    try {
      List<DailyTask> dailyTasks = await DailyTaskApi.findCurrentDailyTask();
      List<Expedition> expeditions = await ExpeditionApi.findAll();
      emit(HomeState(
          dailyTasks: dailyTasks, expeditions: expeditions, isLoading: false));
      return state.copyWith(
        dailyTasks: dailyTasks,
        expeditions: expeditions,
        isLoading: false,
      );
    } catch (e) {
      emit(const HomeState(isLoading: false));
      return state.copyWith(isLoading: false);
    }
  }

  Future<HomeState> _dailyTaskOnSave(
      DailyTaskOnSave event, Emitter<HomeState> emit) async {
    try {
      DailyTask dailyTask = await DailyTaskApi.post(event.dailyTask);
      emit(HomeState(dailyTask: dailyTask, isLoading: false));
      return state.copyWith(
        dailyTask: dailyTask,
        isLoading: false,
      );
    } catch (e) {
      emit(const HomeState(isLoading: false));
      return state.copyWith(isLoading: false);
    }
  }
}
