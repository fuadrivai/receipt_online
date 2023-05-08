import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/library/interceptor/injector.dart';
import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/library/string_uppercase.dart';
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
        DailyTaskState dailyTaskState = await _searchReceipt(event, emit);
        emit(dailyTaskState);
      }
      if (event is ClearSearch) {
        // emit(const DailyTaskState(isLoading: true));
        DailyTaskState dailyTaskState = await _clearSearch(event, emit);
        emit(dailyTaskState);
      }
    });
  }
  Future<DailyTaskState> _clearSearch(
      ClearSearch event, Emitter<DailyTaskState> emit) async {
    DailyTask? dailyTask = state.dailyTask;
    DailyTask? tempDailyTask = _mapTempDailyTask(dailyTask!);

    return state.copyWith(
      isLoading: false,
      dailyTask: dailyTask,
      tempDailyTask: tempDailyTask,
    );
  }

  Future<DailyTaskState> _searchReceipt(
      SearchReceipt event, Emitter<DailyTaskState> emit) async {
    DailyTask? dailyTask = state.dailyTask;
    DailyTask? tempDailyTask = state.tempDailyTask;

    tempDailyTask?.receipts = (dailyTask?.receipts ?? []).where((e) {
      List<String> listNumber = [];
      for (var rune in (e.number ?? "").runes) {
        var character = String.fromCharCode(rune);
        listNumber.add(character.upperCase());
      }
      e.number = listNumber.join();
      return (e.number ?? "").contains(event.number);
    }).toList();
    return state.copyWith(
      isLoading: false,
      dailyTask: dailyTask,
      tempDailyTask: tempDailyTask,
    );
  }

  Future<DailyTaskState> _getDailyTask(
      GetDailyTask event, Emitter<DailyTaskState> emit) async {
    try {
      int id = event.id;
      DailyTask dailyTask = await DailyTaskApi.findById(id);
      DailyTask tempDailyTask = _mapTempDailyTask(dailyTask);

      emit(DailyTaskState(
        dailyTask: dailyTask,
        tempDailyTask: tempDailyTask,
        isLoading: false,
      ));
      return state.copyWith(
        dailyTask: dailyTask,
        tempDailyTask: tempDailyTask,
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
        DailyTask tempDailyTask = _mapTempDailyTask(dailyTask);
        emit(DailyTaskState(
            dailyTask: dailyTask,
            tempDailyTask: tempDailyTask,
            isLoading: false));
        return state.copyWith(
          dailyTask: dailyTask,
          tempDailyTask: tempDailyTask,
          isLoading: false,
        );
      } else {
        DailyTask dailyTask = await DailyTaskApi.findById(event.id);
        DailyTask tempDailyTask = _mapTempDailyTask(dailyTask);
        emit(DailyTaskState(
            dailyTask: dailyTask,
            tempDailyTask: tempDailyTask,
            isLoading: false));
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
          tempDailyTask: tempDailyTask,
          isLoading: false,
        );
      }
    } catch (e) {
      DailyTask dailyTask = await DailyTaskApi.findById(event.id);
      DailyTask tempDailyTask = _mapTempDailyTask(dailyTask);
      emit(DailyTaskState(
          dailyTask: dailyTask,
          tempDailyTask: tempDailyTask,
          isLoading: false));
      return state.copyWith(
        dailyTask: dailyTask,
        tempDailyTask: dailyTask,
        isLoading: false,
      );
    }
  }

  Future<DailyTaskState> _removeReceipt(
      RemoveReceipt event, Emitter<DailyTaskState> emit) async {
    try {
      await DailyTaskApi.deleteReceipt(event.number);
      DailyTask dailyTask = await DailyTaskApi.findById(state.dailyTask!.id!);
      DailyTask tempDailyTask = _mapTempDailyTask(dailyTask);
      emit(DailyTaskState(
          dailyTask: dailyTask,
          tempDailyTask: tempDailyTask,
          isLoading: false));
      return state.copyWith(
        dailyTask: dailyTask,
        tempDailyTask: dailyTask,
        isLoading: false,
      );
    } catch (e) {
      DailyTask dailyTask = await DailyTaskApi.findById(state.dailyTask!.id!);
      DailyTask tempDailyTask = _mapTempDailyTask(dailyTask);
      emit(DailyTaskState(
          dailyTask: dailyTask,
          tempDailyTask: tempDailyTask,
          isLoading: false));
      return state.copyWith(
        dailyTask: dailyTask,
        tempDailyTask: dailyTask,
        isLoading: false,
      );
    }
  }

  DailyTask _mapTempDailyTask(DailyTask dailyTask) {
    DailyTask tempDailyTask = DailyTask(
      createdAt: dailyTask.createdAt,
      date: dailyTask.date,
      expedition: dailyTask.expedition,
      id: dailyTask.id,
      left: dailyTask.left,
      picked: dailyTask.picked,
      status: dailyTask.status,
      totalPackage: dailyTask.totalPackage,
      updatedAt: dailyTask.updatedAt,
      receipts:
          (dailyTask.receipts ?? []).map((e) => Receipt.clone(e)).toList(),
    );
    return tempDailyTask;
  }
}
