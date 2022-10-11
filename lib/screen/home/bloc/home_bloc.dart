import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/library/interceptor/injector.dart';
import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/screen/daily_task/data/daily_task_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition_api.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final NavigationService _nav = locator<NavigationService>();
  HomeBloc() : super(const HomeState()) {
    on<HomeEvent>((event, emit) async {
      if (event is GetCurrentDailyTask) {
        emit(const HomeState(isLoading: true));
        HomeState homeState = await _getExpedition(event, emit);
        emit(homeState);
      }
      if (event is DailyTaskOnSave) {
        // Navigator.pop(_nav.navKey.currentContext!);
        emit(const HomeState(isLoading: true));
        HomeState homeState = await _dailyTaskOnSave(event, emit);
        emit(homeState);
      }
    });
    on<OnChangeTotal>((event, emit) => onChangeTotal(event, emit));
    on<OnChangeExpedition>((event, emit) => onChangeExpedition(event, emit));
  }

  onChangeTotal(OnChangeTotal event, Emitter<HomeState> emit) {
    DailyTask dailyTask = state.dailyTask ?? DailyTask();
    dailyTask.totalPackage = event.total;
    emit(HomeState(dailyTask: dailyTask));
    return state.copyWith(
      dailyTask: dailyTask,
    );
  }

  onChangeExpedition(OnChangeExpedition event, Emitter<HomeState> emit) {
    DailyTask dailyTask = state.dailyTask ?? DailyTask();
    dailyTask.expedition = event.expedition;
    emit(HomeState(dailyTask: dailyTask));
    return state.copyWith(
      dailyTask: dailyTask,
    );
  }

  Future<HomeState> _dailyTaskOnSave(
      DailyTaskOnSave event, Emitter<HomeState> emit) async {
    try {
      DailyTask dailyTask = state.dailyTask ?? DailyTask();
      dailyTask.date = Jiffy(DateTime.now()).format("yyyy-MM-dd");
      await DailyTaskApi.post(dailyTask);
      List<DailyTask> dailyTasks = await DailyTaskApi.findCurrentDailyTask();
      emit(HomeState(isLoading: false, dailyTasks: dailyTasks));
      return state.copyWith(isLoading: false, dailyTasks: dailyTasks);
    } catch (e) {
      List<DailyTask> dailyTasks = await DailyTaskApi.findCurrentDailyTask();
      emit(HomeState(isLoading: false, dailyTasks: dailyTasks));
      return state.copyWith(isLoading: false, dailyTasks: dailyTasks);
    }
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
}
