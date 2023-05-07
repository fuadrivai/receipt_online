import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/library/interceptor/injector.dart';
import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/model/receipt.dart';
import 'package:receipt_online_shop/screen/daily_task/data/daily_task_api.dart';
import 'package:receipt_online_shop/screen/daily_task/data/expedition_enum.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';

part 'daily_task_event.dart';
part 'daily_task_state.dart';

final NavigationService _nav = locator<NavigationService>();

class DailyTaskBloc extends Bloc<DailyTaskEvent, DailyTaskState> {
  DailyTaskBloc() : super(const DailyTaskState()) {
    on<DailyTaskEvent>((event, emit) async {
      if (event is GetDailyTask) {
        emit(const DailyTaskState(isLoading: true));
        DailyTaskState dailyTaskState = await _getDailyTask(event, emit);
        emit(dailyTaskState);
      }
      if (event is PostReceipt) {
        // emit(const DailyTaskState(isLoading: true));
        DailyTaskState dailyTaskState = await _postReceipt(event, emit);
        emit(dailyTaskState);
      }
      if (event is RemoveReceipt) {
        // emit(const DailyTaskState(isLoading: true));
        DailyTaskState dailyTaskState = await _removeReceipt(event, emit);
        emit(dailyTaskState);
      }
      if (event is SearchReceipt) {
        // emit(const DailyTaskState(isLoading: true));
        DailyTaskState dailyTaskState = _searchReceipt(event, emit);
        emit(dailyTaskState);
      }
    });
  }
  _searchReceipt<DailyTaskState>(
      SearchReceipt event, Emitter<DailyTaskState> emit) {
    DailyTask? dailyTask = state.tempDailyTask;

    List<Receipt> receipts = (dailyTask?.receipts ?? [])
        .where(
            (e) => e.number!.toLowerCase().contains(event.number.toLowerCase()))
        .toList();
    state.tempDailyTask?.receipts = receipts;
    // emit((state.tempDailyTask = dailyTask) as DailyTaskState);
  }

  Future<DailyTaskState> _getDailyTask(
      GetDailyTask event, Emitter<DailyTaskState> emit) async {
    try {
      int id = event.id;
      DailyTask dailyTask = await DailyTaskApi.findById(id);
      emit(DailyTaskState(
          dailyTask: dailyTask, tempDailyTask: dailyTask, isLoading: false));
      return state.copyWith(
        dailyTask: dailyTask,
        isLoading: false,
      );
    } catch (e) {
      emit(const DailyTaskState(isLoading: false, isError: true));
      return state.copyWith(isLoading: false);
    }
  }

  Future<DailyTaskState> _postReceipt(
      PostReceipt event, Emitter<DailyTaskState> emit) async {
    try {
      bool valid = ValidExpedition.validReceipt(
        platform: event.platform,
        data: event.barcode,
      );
      if (valid) {
        Receipt receipt = Receipt();
        receipt.number = event.barcode;
        await DailyTaskApi.posReceipt(event.id, receipt);
        DailyTask dailyTask = await DailyTaskApi.findById(event.id);
        emit(DailyTaskState(dailyTask: dailyTask, isLoading: false));
        return state.copyWith(
          dailyTask: dailyTask,
          isLoading: false,
        );
      } else {
        DailyTask dailyTask = await DailyTaskApi.findById(event.id);
        emit(DailyTaskState(dailyTask: dailyTask, isLoading: false));
        Common.modalInfo(
          _nav.navKey.currentContext!,
          title: "Error",
          message: "${event.barcode} - Resi Tidak Valid",
          icon: const Icon(
            Icons.cancel_outlined,
            color: Colors.red,
            size: 30,
          ),
        );
        return state.copyWith(
          dailyTask: dailyTask,
          isLoading: false,
        );
      }
    } catch (e) {
      DailyTask dailyTask = await DailyTaskApi.findById(event.id);
      emit(DailyTaskState(dailyTask: dailyTask, isLoading: false));
      return state.copyWith(
        dailyTask: dailyTask,
        isLoading: false,
      );
    }
  }

  Future<DailyTaskState> _removeReceipt(
      RemoveReceipt event, Emitter<DailyTaskState> emit) async {
    try {
      await DailyTaskApi.deleteReceipt(event.number);
      DailyTask dailyTask = await DailyTaskApi.findById(state.dailyTask!.id!);
      emit(DailyTaskState(dailyTask: dailyTask, isLoading: false));
      return state.copyWith(
        dailyTask: dailyTask,
        isLoading: false,
      );
    } catch (e) {
      DailyTask dailyTask = await DailyTaskApi.findById(state.dailyTask!.id!);
      emit(DailyTaskState(dailyTask: dailyTask, isLoading: false));
      return state.copyWith(
        dailyTask: dailyTask,
        isLoading: false,
      );
    }
  }
}
