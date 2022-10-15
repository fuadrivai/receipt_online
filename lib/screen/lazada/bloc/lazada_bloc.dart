import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/model/lazada/full_order.dart';
import 'package:receipt_online_shop/model/lazada/order.dart';
import 'package:receipt_online_shop/screen/lazada/data/lazada_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lazada_event.dart';
part 'lazada_state.dart';

class LazadaBloc extends Bloc<LazadaEvent, LazadaState> {
  LazadaBloc() : super(const LazadaState()) {
    on<LazadaEvent>((event, emit) async {
      if (event is GetFullOder) {
        emit(const LazadaState(isLoading: true));
        LazadaState lazadaState = await _getFullOrder(event, emit);
        emit(lazadaState);
      }
      if (event is GetSingleOrder) {
        // emit(const LazadaState(isLoading: true));
        // LazadaState lazadaState = ;
        emit(await _getSingleOrder(event, emit));
      }
    });
  }

  Future<LazadaState> _getFullOrder(
      GetFullOder event, Emitter<LazadaState> emit) async {
    try {
      FullOrder fullOrder = await LazadaApi.getOrders();
      LazadaState(fullOrder: fullOrder, isLoading: false);
      return state.copyWith(
        fullOrder: fullOrder,
        isLoading: false,
      );
    } catch (e) {
      emit(const LazadaState(isLoading: false));
      return state.copyWith(isLoading: false);
    }
  }

  Future<LazadaState> _getSingleOrder(
      GetSingleOrder event, Emitter<LazadaState> emit) async {
    try {
      // const LazadaState(isLoading: true);
      Order order = await LazadaApi.getOrder(event.orderId);
      LazadaState(order: order, isLoading: false);
      return state.copyWith(
        order: order,
        isLoading: false,
      );
    } catch (e) {
      emit(const LazadaState(isLoading: false));
      return state.copyWith(isLoading: false);
    }
  }
}
