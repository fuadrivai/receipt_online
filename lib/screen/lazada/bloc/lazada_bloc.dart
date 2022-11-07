import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/library/seesion_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/model/lazada/lazada_count.dart';
import 'package:receipt_online_shop/model/shopee/logistic.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/lazada/data/lazada_api.dart';

part 'lazada_event.dart';
part 'lazada_state.dart';

class LazadaBloc extends Bloc<LazadaEvent, LazadaState> {
  LazadaBloc() : super(LazadaLoadingState()) {
    on<OnChangeSortingEvent>(_onChangeSorting);
    on<GetOrders>(_onGetOrders);
  }

  void _onChangeSorting(
      OnChangeSortingEvent event, Emitter<LazadaState> emit) async {
    try {
      emit(LazadaLoadingState());
      Session.set("sorting", event.sorting);
      List<TransactionOnline> transactions = await getOrders(event.tab);
      List<LogisticChannel> logistics = [];
      for (TransactionOnline order in transactions) {
        LogisticChannel exitingChannel = logistics.firstWhere(
            (data) => data.name == order.shippingProviderType,
            orElse: () => LogisticChannel());
        if (exitingChannel.name == null) {
          LogisticChannel logistic =
              LogisticChannel(name: order.pickupBy, totalOrder: 1);
          logistics.add(logistic);
        } else {
          exitingChannel.totalOrder = exitingChannel.totalOrder! + 1;
        }
      }
      LazadaCount count = await LazadaApi.getCount();
      emit(LazadaOnChangeState(event.sorting, event.tab));
      emit(LazadaFullOrderState(transactions, count, transactions, logistics));
    } catch (e) {
      emit(LazadaErrorState());
    }
  }

  void _onGetOrders(GetOrders event, Emitter<LazadaState> emit) async {
    try {
      emit(LazadaLoadingState());
      LazadaCount count = await LazadaApi.getCount();
      List<TransactionOnline> transactions = await getOrders(event.tab);
      List<LogisticChannel> logistics = [];
      for (TransactionOnline order in transactions) {
        LogisticChannel exitingChannel = logistics.firstWhere(
            (data) => data.name == order.shippingProviderType,
            orElse: () => LogisticChannel());
        if (exitingChannel.name == null) {
          LogisticChannel logistic =
              LogisticChannel(name: order.shippingProviderType, totalOrder: 1);
          logistics.add(logistic);
        } else {
          exitingChannel.totalOrder = exitingChannel.totalOrder! + 1;
        }
      }
      emit(LazadaFullOrderState(transactions, count, transactions, logistics));
    } catch (e) {
      emit(LazadaErrorState());
    }
  }

  Future<List<TransactionOnline>> getOrders(int tabIndex) async {
    String status = "packed";
    switch (tabIndex) {
      case 0:
        status = "pending";
        break;
      case 1:
        status = "packed";
        break;
      case 2:
        status = "ready_to_ship";
        break;
      default:
        status = "packed";
        break;
    }
    String? sorting = await Session.get("sorting");
    return await LazadaApi.getorders(status, sorting ?? "DESC");
  }
}
