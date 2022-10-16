import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/model/lazada/full_order.dart';
import 'package:receipt_online_shop/model/lazada/order.dart';
import 'package:receipt_online_shop/screen/lazada/data/lazada_api.dart';

part 'platform_event.dart';
part 'platform_state.dart';

class PlatformBloc extends Bloc<PlatformEvent, PlatformState> {
  PlatformBloc() : super(PlatformLoading()) {
    on<PlatformFullOder>(_getFullOrder);
    on<PlatformSingleOrder>(_getSingleOrder);
  }

  void _getFullOrder(
      PlatformFullOder event, Emitter<PlatformState> emit) async {
    emit(PlatformLoading());
    try {
      FullOrder fullOrder = await LazadaApi.getOrders();
      emit(PlatformLoaded(fullOrder));
    } catch (e) {
      emit(PlatformError());
    }
  }

  void _getSingleOrder(
      PlatformSingleOrder event, Emitter<PlatformState> emit) async {
    emit(LoadingSingle());
    try {
      Order order = await LazadaApi.getOrder(event.orderId);
      emit(PlatformOrder(order));
    } catch (e) {
      emit(PlatformError());
    }
  }
}
