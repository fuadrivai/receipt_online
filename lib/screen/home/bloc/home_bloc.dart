import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
  HomeBloc() : super(HomeLoadingState()) {
    on<GetData>(_getData);
    on<OnChangeExpedition>(_onChangeExpedition);
    on<OnChangeTotal>(_onChangeTotal);
    on<OnSaveDailyTask>(_onSaveDailyTask);
  }

  void _getData(GetData event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoadingState());
      List<DailyTask> dailyTasks = await DailyTaskApi.findCurrentDailyTask();
      List<Expedition> expeditions = await ExpeditionApi.findAll();
      emit(DataState(dailyTasks: dailyTasks, expeditions: expeditions));
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  void _onChangeExpedition(
      OnChangeExpedition event, Emitter<HomeState> emit) async {
    try {
      final state =
          BlocProvider.of<HomeBloc>(_nav.navKey.currentContext!).state;
      if (state is DataState) {
        DailyTask dailyTask = state.dailyTask ?? DailyTask();
        dailyTask.expedition = event.expedition;
        emit(DataState(
          dailyTask: dailyTask,
          dailyTasks: state.dailyTasks,
          expeditions: state.expeditions,
        ));
      }
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  void _onChangeTotal(OnChangeTotal event, Emitter<HomeState> emit) async {
    try {
      final state =
          BlocProvider.of<HomeBloc>(_nav.navKey.currentContext!).state;
      if (state is DataState) {
        DailyTask dailyTask = state.dailyTask ?? DailyTask();
        dailyTask.totalPackage = event.totalPackage;
        emit(DataState(
          dailyTask: dailyTask,
          dailyTasks: state.dailyTasks,
          expeditions: state.expeditions,
        ));
      }
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  void _onSaveDailyTask(OnSaveDailyTask event, Emitter<HomeState> emit) async {
    try {
      final state =
          BlocProvider.of<HomeBloc>(_nav.navKey.currentContext!).state;
      if (state is DataState) {
        DailyTask dailyTask = state.dailyTask ?? DailyTask();
        dailyTask.date = Jiffy.now().format(pattern: "yyyy-MM-dd");
        await DailyTaskApi.post(dailyTask);
        Navigator.pop(_nav.navKey.currentContext!);
        // List<DailyTask> dailyTasks = await DailyTaskApi.findCurrentDailyTask();
        emit(DataState(
          dailyTasks: state.dailyTasks,
          expeditions: state.expeditions,
        ));
      }
    } catch (e) {
      emit(HomeErrorState(e.toString()));
      Navigator.pop(_nav.navKey.currentContext!);
    }
  }
}
