import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/library/seesion_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/lazada/data/lazada_api.dart';

part 'lazada_event.dart';
part 'lazada_state.dart';

class LazadaBloc extends Bloc<LazadaEvent, LazadaState> {
  LazadaBloc() : super(LazadaLoadingState()) {
    on<OnChangeSortingEvent>(_onChangeSorting);
    on<OnRefresh>(_onRefresh);
    on<GetOrders>(_onGetOrders);
  }

  void _onRefresh(OnRefresh event, Emitter<LazadaState> emit) async {
    try {
      emit(LazadaLoadingState());
      List<TransactionOnline> transactions = [];
      String sorting = await Session.get("sorting") ?? "DESC";
      switch (event.tab) {
        case 0:
          transactions = await LazadaApi.getorders("pending", sorting);
          break;
        case 1:
          transactions = await LazadaApi.getorders("packed", sorting);
          break;
        case 2:
          transactions = await LazadaApi.getorders("ready_to_ship", sorting);
          break;
        default:
          transactions = await LazadaApi.getorders("packed", sorting);
          break;
      }
      emit(LazadaFullOrderState(transactions));
    } catch (e) {
      emit(LazadaErrorState());
    }
  }

  void _onChangeSorting(
      OnChangeSortingEvent event, Emitter<LazadaState> emit) async {
    try {
      emit(LazadaLoadingState());
      List<TransactionOnline> transactions = [];
      Session.set("sorting", event.sorting);
      switch (event.tab) {
        case 0:
          transactions = await LazadaApi.getorders("pending", event.sorting);
          break;
        case 1:
          transactions = await LazadaApi.getorders("packed", event.sorting);
          break;
        case 2:
          transactions =
              await LazadaApi.getorders("ready_to_ship", event.sorting);
          break;
        default:
          transactions = await LazadaApi.getorders("packed", event.sorting);
          break;
      }
      emit(LazadaOnChangeState(event.sorting, event.tab));
      emit(LazadaFullOrderState(transactions));
    } catch (e) {
      emit(LazadaErrorState());
    }
  }

  void _onGetOrders(GetOrders event, Emitter<LazadaState> emit) async {
    try {
      emit(LazadaLoadingState());
      Session.set("sorting", event.sorting);
      List<TransactionOnline> transactions =
          await LazadaApi.getorders("packed", event.sorting);
      emit(LazadaOnChangeState(event.sorting, event.tab));
      emit(LazadaFullOrderState(transactions));
    } catch (e) {
      emit(LazadaErrorState());
    }
  }
}
